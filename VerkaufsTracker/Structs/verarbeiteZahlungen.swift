//
//  verarbeiteZahlungen.swift
//  
//
//  Created by Benedict on 22.01.23.
//

import Foundation

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

	init(v: Verwaltung, ao: AktionObserver) {
		self.v = v
		self.ao = ao
		ao.activate(name: "importiere Zahlungen")
		ao.log("Starte Import")
		ao.setPrompt("CSV auswählen")
	}

}
