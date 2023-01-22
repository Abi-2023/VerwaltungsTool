//
//  verarbeiteZahlungen.swift
//  
//
//  Created by Benedict on 22.01.23.
//

import Foundation
import SwiftCSV

// Betrag in cent
fileprivate func uploadZahlung(person: Person, betrag: Int, notiz: String) -> Bool{
	let transaktionsQuery = "***REMOVED***viewform?usp=pp_url"

	guard let requestUrl = URL(string: transaktionsQuery) else {
		print("invalid url")
		return false
	}
	// Prepare URL Request Object
	var request = URLRequest(url: requestUrl)
	request.httpMethod = "POST"

	// HTTP Request Parameters which will be sent in HTTP Request Body
	let postString = "entry.635762291=\(person.id)&entry.1349648930=\(betrag)&entry.1884599919=\(notiz.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "FEHLER")"
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
	return !fehler
}


class ZahlungsVerarbeiter: ObservableObject {

	let v: Verwaltung
	let ao: AktionObserver

	@Published var hatImportiert = false

	init(v: Verwaltung, ao: AktionObserver) {
		self.v = v
		self.ao = ao
		ao.activate(name: "importiere Zahlungen")
		ao.log("Starte Import")
		ao.setPrompt("CSV auswählen")
	}

	func verarbeiteCSV(str: String) {
		DispatchQueue.global(qos: .default).async {
			do {
				let csv = try EnumeratedCSV(string: str, delimiter: .semicolon, loadColumns: false)
				try csv.enumerateAsArray(startAt: 1,rowLimit: nil) { element in
					self.verarbeiteReihe(arr: element)
				}
				DispatchQueue.main.async {
					self.hatImportiert = true
				}
			} catch {
				print("csv error: \(error)")
			}
		}
	}

	func verarbeiteReihe(arr: [String]) {
		var hasher = Hasher()
		hasher.combine(arr)
		let hash = hasher.finalize()
		if(arr.count != 17) {
			ao.log("Spaltenzahl stimmt nicht \(arr.count)")
			return
		}

		var kommentar = ""

		var person: Person? = nil
		if let formId = NSRegularExpression.getMatches(regex: "[ABCDEF][175963][SEFWQX][MNDQS5][W3YJ52]", inputText: arr[4].uppercased()).first {
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
			betrag = -1
		} else {
			let split = betragStr.split(separator: ",")
			let euro = Int(split[0])
			let cent = Int(split[1])

			if euro != nil && cent != nil {
				betrag = 100 * euro! + cent!
			} else {
				kommentar += "betrag invalide: \(arr[14])"
				betrag = -1
			}
		}

		let valid = betrag > 0 && person != nil

		let eintrag = Eintrag(datum: arr[1],
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
		var datum: String
		var buchungstext: String
		var zweck: String
		var zahlungsPerson: String
		var betrag: String
		var info: String

		var erkanntePerson: Person?
		var erkannterBetrag: Int

		var kommentar: String
		var valid: Bool //ob die automatischen werte stimmen könnten
	}

	@Published var eintraege: [Eintrag] = []

	func ignorieren() {

	}

	func spaeter() {
		eintraege.removeFirst()
	}

	func hinzufuegen() {

	}
}
