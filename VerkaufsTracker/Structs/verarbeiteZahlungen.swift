//
//  verarbeiteZahlungen.swift
//  
//
//  Created by Benedict on 22.01.23.
//

import Foundation
import SwiftCSV

import CryptoKit

func MD5(string: String) -> String {
	let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

	return digest.map {
		String(format: "%02hhx", $0)
	}.joined()
}


// Betrag in cent
fileprivate func uploadZahlung(person: Person, betrag: Int, notiz: String) -> Bool{
	let transaktionsQuery = "/formResponse"

	guard let requestUrl = URL(string: transaktionsQuery) else {
		print("invalid url")
		return false
	}
	// Prepare URL Request Object
	var request = URLRequest(url: requestUrl)
	request.httpMethod = "POST"

	// HTTP Request Parameters which will be sent in HTTP Request Body
	let postString = "entry.635762291=\(person.formID)&entry.1349648930=\(betrag)&entry.1884599919=\(notiz.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "FEHLER")"
	// Set HTTP Request Body
	request.httpBody = postString.data(using: String.Encoding.utf8)
	// Perform HTTP Request
	let workerGroup = DispatchGroup()
	workerGroup.enter()
	var fehler = false
	let task = URLSession.shared.dataTask(with: request) { (_, _, error) in
		// Check for Error
		if let error = error {
			print("Error took place \(error)")
			fehler = true
		}
		workerGroup.leave()
	}
	task.resume()
	workerGroup.wait()
	return !fehler
}


class ZahlungsVerarbeiter: ObservableObject {

	let v: Verwaltung
	let ao: AktionObserver

	@Published var hatImportiert = false

	init(v: Verwaltung, ao: AktionObserver) {
		self.v = v
		self.ao = ao
		DispatchQueue.global(qos: .userInitiated).async {
			ao.activate(name: "importiere Zahlungen")
			ao.log("Starte Import")
			ao.setPrompt("CSV auswählen")
		}
	}

	func verarbeiteCSV(str: String) {
		DispatchQueue.global(qos: .default).async {
			do {
				let csv = try EnumeratedCSV(string: str, delimiter: .semicolon, loadColumns: false)
				try csv.enumerateAsArray(startAt: 1,rowLimit: nil) { element in
					self.verarbeiteReihe(arr: element)
				}
				self.ao.log("\(csv.rows.count) Einträge importiert")
				self.ao.log("\(csv.rows.count - self.eintraege.count) bereits verarbeitet")
				self.ao.log("\(self.eintraege.count) noch nicht verarbeitet")

				DispatchQueue.main.async {
					self.hatImportiert = true
				}
			} catch {
				print("csv error: \(error)")
			}
		}
	}

	func verarbeiteReihe(arr: [String]) {
		let hash = MD5(string: arr.joined())

		if v.verarbeiteteZahlungenHashs.contains(hash) {
			return
		}

		if(arr.count != 17) {
			ao.log("Spaltenzahl stimmt nicht \(arr.count)")
			return
		}

		var kommentar = ""

		var person: Person? = nil
		if let formId = NSRegularExpression.getMatches(regex: "([ABCDEF][175963][SEFWQX][MNDQS5][W3YJ52])", inputText: arr[4].uppercased()).first {
			if let pM = v.personen.first(where: {$0.formID == formId}) {
				person = pM
			} else {
				// Form id nicht richtig
				kommentar += "formId nicht gefunden"
			}
		} else {
			// Der Verwendungszwecke enthält keine FormId
			kommentar += "keine FormId im Zweck"
		}


		if arr[15] != "EUR" {
			kommentar += "falsche Währung: \(arr[15])"
		}
		let betragStr = arr[14]
		let betrag: Int
		if betragStr.contains("-") {
			kommentar += "betragNegativ: \(arr[14])"
			betrag = 0
		} else {
			let split = betragStr.split(separator: ",")
			let euro = Int(split[0])
			let cent = Int(split[1])

			if euro != nil && cent != nil {
				betrag = 100 * euro! + cent!
			} else {
				kommentar += "betrag invalide: \(arr[14])"
				betrag = 0
			}
		}

		let valid = betrag > 0 && person != nil

		let eintrag = Eintrag(hash: hash,
							  datum: arr[1],
							  buchungstext: arr[3],
							  zweck: arr[4],
							  zahlungsPerson: arr[11],
							  betrag: arr[14],
							  info: arr[16],
							  erkanntePerson: person,
							  erkannterBetrag: betrag,
							  kommentar: kommentar,
							  valid: valid)
		self.eintraege.append(eintrag)
	}

	struct Eintrag {
		let hash: String
		let datum: String
		let buchungstext: String
		let zweck: String
		let zahlungsPerson: String
		let betrag: String
		let info: String

		let erkanntePerson: Person?
		let erkannterBetrag: Int

		let kommentar: String
		let valid: Bool //ob die automatischen werte stimmen könnten
	}

	@Published var eintraege: [Eintrag] = []

	func ignorieren() {
		guard let eintrag = eintraege.first else {
			return
		}
		v.verarbeiteteZahlungenHashs.append(eintrag.hash)
		eintraege.removeFirst()
	}

	func spaeter() {
		eintraege.removeFirst()
	}

	func hinzufuegen() {
		guard let eintrag = eintraege.first else {
			return
		}
		v.verarbeiteteZahlungenHashs.append(eintrag.hash)
		DispatchQueue.global().async {
			if uploadZahlung(person: eintrag.erkanntePerson!, betrag: eintrag.erkannterBetrag, notiz: "\(eintrag.hash); \(CloudStatus.deviceName() ?? "?") - \(Date().formatted(.dateTime))") {
				self.ao.log("Zahlung hinzugefuegt: \(eintrag.erkanntePerson!.name) \(eintrag.betrag) | \(eintrag.hash)")
			} else {
				self.ao.log("Zahlung konnte nicht hinzugefuegt werden")
			}
		}
		eintraege.removeFirst()
	}


	func fertig() {
		DispatchQueue.global().async {
			self.ao.log("beenden")
			self.ao.finish()
		}
	}
}
