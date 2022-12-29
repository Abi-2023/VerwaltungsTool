//
//  Aktion_ImportTransaktionen.swift
//  
//
//  Created by Benedict on 28.12.22.
//

import Foundation

extension Aktion {

	// TODO: schöner machen und bessere logs
	static func fetchTransaktionen(verwaltung v: Verwaltung, ao: AktionObserver) {
		ao.activate(name: "fetch Transaktionen")
		ao.log("clear Transaktionsdata")
		DispatchQueue.main.async {
			v.transaktionen = []
		}

		func processTransaktionsEntry(entry e: [String], range: String) -> Bool{
			let user_form_id = e[safe: 0]
			let betrag = e[safe: 1]

			if user_form_id == nil || betrag == nil {
				ao.log("error parsing entry: \(user_form_id ?? "?"), \(betrag ?? "?"), \(range)")
				return false
			}

			guard let person = v.personen.first(where: {$0.formID == user_form_id}) else {
				ao.log("keine Person mit folgender ID gefunden: \(user_form_id ?? "?"), \(range)")
				return false
			}

			let betragCent = Int(betrag!)

			guard let betragCent else {
				ao.log("betragInvalid: \(user_form_id ?? "?"), \(betrag ?? "?"), \(range)")
				return false
			}

			if betragCent < 500 {
				ao.log("betrag sehr niedrig: \(user_form_id ?? "?"), \(betragCent), \(range)")
			}

			let transaktion = Transaktion(betrag: betragCent, personId: person.id)
			DispatchQueue.main.async {
				v.transaktionen.append(transaktion)
			}
			return true
		}


		let wait = DispatchSemaphore(value: 0)

		let ranges: [String] = [
			"'Formularantworten 1'!B2:C500",
			"CSVImport!A2:B500",
			"Manuell!A2:B500",
		]
		for range in ranges {
			let URL_TO_DATA = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(SECRETS.TRANSAKTIONEN_ID)/values:batchGet?key=\(SECRETS.FORM_ApiKey)&ranges=\(range)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
			ao.log("make Api Call to google forms")
			let task = URLSession.shared.dataTask(with: URL_TO_DATA) {(data, response, error) in
				guard let data = data else { return }
				ao.log("responded")

				let result = String(data: data, encoding: .utf8)!
				if(result.contains("valueRanges")){
					let dict = ((((result.convertToDictionary()!["valueRanges"]! as! [Any])[0]) as! [String: Any]) ["values"]) as! [[String]]
					ao.log("fetched \(dict.count) entries")
					var success = 0
					for entry in dict {
						if processTransaktionsEntry(entry: entry, range: String(range.prefix(5))) {
							success += 1
						}
					}

					ao.log("\(success)/\(dict.count) entries from range \(String(range.prefix(5))) are valid")

					wait.signal()
				}else{
					print("fehler bei der Api antwort")
					ao.log("fehler bei der API Antwort")
					print(result)
				}
			}

			task.resume()
		}

		let timeoutResult = wait.wait(timeout: .now() + 10)
		if(timeoutResult == .timedOut){
			ao.log("timout")
			print("timeout")
		}
		ao.log("finish")
		ao.finish()
	}

}
