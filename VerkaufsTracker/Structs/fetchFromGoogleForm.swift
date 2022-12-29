//
//  fetchFromGoogleForm.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import Foundation

extension Aktion {

	static func fetchFromGoogleForm(verwaltung v: Verwaltung, ao: AktionObserver) {
		ao.activate(name: "Fetch Umfrageergebnisse")

		func processEntry(entry e: [String]) -> Bool{
			let id = e[safe: 1]
			let name = e[safe: 2]
			let ballTickets = Int(e[safe: 3] ?? "")
			let afterShowTickets = Int(e[safe: 4] ?? "")

			if id == nil || name == nil || ballTickets == nil || afterShowTickets == nil {
				ao.log("error parsing entry: \(id ?? "?"), \(name ?? "?"), \(ballTickets ?? -1), \(afterShowTickets ?? -1)")
				return false
			}

			guard let person = v.personen.first(where: {$0.formID == id}) else {
				ao.log("keine Person mit folgender ID gefunden: \(id ?? "?"), \(name ?? "?")")
				return false
			}

			if name!.replacingOccurrences(of: " ", with: "") != person.formName.replacingOccurrences(of: " ", with: "") {
				ao.log("name und ID passen nicht: \(id ?? "?"), \(name ?? "?")")
				return false
			}

			if ballTickets! < 0 || ballTickets! > 10 || afterShowTickets! < 0 || afterShowTickets! > 10 {
				ao.log("Anzahl kann nicht stimmen: \(id ?? "?"), \(name ?? "?"), \(ballTickets ?? -1), \(afterShowTickets ?? -1)")
				return false
			}

			//person gefunden
			person.wuenschBestellungen[.ball_ticket] = ballTickets!
			person.wuenschBestellungen[.after_show_ticket] = afterShowTickets!
			person.extraFields["hatFormEingetragen"] = "1"
			ao.log("Für \(person.name) eingetragen")
			return true
		}


		let wait = DispatchSemaphore(value: 0)

		let range = "A2:G500"
		let URL_TO_DATA = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(SECRETS.FORM_ID)/values:batchGet?key=\(SECRETS.FORM_ApiKey)&ranges=\(range)")!
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
					if processEntry(entry: entry) {
						success += 1
					}
				}

				ao.log("\(success)/\(dict.count) entries are valid")

				wait.signal()
			}else{
				print("fehler bei der Api antwort")
				ao.log("fehler bei der API Antwort")
				print(result)
			}
		}

		task.resume()

		let timeoutResult = wait.wait(timeout: .now() + 2)
		if(timeoutResult == .timedOut){
			ao.log("timout")
			print("timeout")
		}
		ao.log("finish")
		ao.finish()
	}

}

extension String {
	func convertToDictionary() -> [String: Any]? {
		if let data = data(using: .utf8) {
			return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		}
		return nil
	}
}

extension Collection {
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
   }
}
