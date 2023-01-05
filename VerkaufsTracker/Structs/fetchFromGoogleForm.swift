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

		var valid = 0
		var deleted = 0

		func processEntry(entry e: [String]) {
			let id = e[safe: 1]
			let name = e[safe: 2]
			let ballTickets = Int(e[safe: 4] ?? "")
			let afterShowTickets = Int(e[safe: 5] ?? "")
			let pulli_xs = Int(e[safe: 6] ?? "")
			let pulli_s = Int(e[safe: 7] ?? "")
			let pulli_m = Int(e[safe: 8] ?? "")
			let pulli_l = Int(e[safe: 9] ?? "")
			let pulli_xl = Int(e[safe: 10] ?? "")
			let buch = Int(e[safe: 11] ?? "")

			if id == "-" {
				deleted += 1
				return
			}

			if id == nil || name == nil || ballTickets == nil || afterShowTickets == nil || pulli_xs == nil || pulli_s == nil || pulli_m == nil || pulli_l == nil || pulli_xl == nil || buch == nil {
				ao.log("error parsing entry: \(e[safe: 0] ?? "?") \(id ?? "?"), \(name ?? "?")")
				return
			}

			guard let person = v.personen.first(where: {$0.formID == id}) else {
				ao.log("keine Person mit folgender ID gefunden: \(e[safe: 0] ?? "?") \(id ?? "?"), \(name ?? "?")")
				return
			}

			if name!.replacingOccurrences(of: " ", with: "") != person.formName.replacingOccurrences(of: " ", with: "") {
				ao.log("name und ID passen nicht: \(e[safe: 0] ?? "?") \(id ?? "?"), \(name ?? "?")")
				return
			}

			if ballTickets! < 0 || afterShowTickets! < 0 || pulli_xs! < 0 || pulli_s! < 0 || pulli_m! < 0 || pulli_l! < 0 || pulli_xl! < 0 || buch! < 0 || ballTickets! > 10 || afterShowTickets! > 10 || pulli_xs! > 3 || pulli_s! > 3 || pulli_m! > 3 || pulli_l! > 3 || pulli_xl! > 3 || buch! > 5 {
				ao.log("Anzahl kann nicht stimmen: \(e[safe: 0] ?? "?") \(id ?? "?"), \(name ?? "?")")
				return
			}

			//person gefunden
			person.wuenschBestellungen[.ball_ticket] = ballTickets!
			person.wuenschBestellungen[.after_show_ticket] = afterShowTickets!
			person.wuenschBestellungen[.buch] = buch!
			person.wuenschBestellungen[.pulli] = pulli_xs! + pulli_s! + pulli_m! + pulli_l! + pulli_xl!

			person.extraFields[.pulli_xs] = String(pulli_xs!)
			person.extraFields[.pulli_s] = String(pulli_s!)
			person.extraFields[.pulli_m] = String(pulli_m!)
			person.extraFields[.pulli_l] = String(pulli_l!)
			person.extraFields[.pulli_xl] = String(pulli_xl!)

			person.extraFields[.hatFormEingetragen] = "1"
			ao.log("Für \(person.name) eingetragen")
			valid += 1
		}


		for range in ["SCHUELER!A2:L500", "LEHRER!A2:L500"] {
			valid = 0
			deleted = 0

			let wait = DispatchGroup()

			let URL_TO_DATA = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(SECRETS.FORM_ID)/values:batchGet?key=\(SECRETS.FORM_ApiKey)&ranges=\(range)")!
			ao.log("make Api Call: \(range.prefix(6))")
			wait.enter()
			let task = URLSession.shared.dataTask(with: URL_TO_DATA) {(data, response, error) in
				guard let data = data else { return }
				ao.log("responded")

				let result = String(data: data, encoding: .utf8)!
				if(result.contains("valueRanges")){
					let dict = ((((result.convertToDictionary()!["valueRanges"]! as! [Any])[0]) as! [String: Any]) ["values"]) as! [[String]]
					ao.log("fetched \(dict.count) entries")
					for entry in dict {
						processEntry(entry: entry)
					}

					ao.log("\(deleted) disabled")
					ao.log("\(valid)/\(dict.count - deleted) entries are valid")
					DispatchQueue.main.async {
						v.lastFetchForm = .now
					}

					wait.leave()
				}else{
					print("fehler bei der Api antwort")
					ao.log("fehler bei der API Antwort")
					print(result)
				}
			}

			task.resume()

			let timeoutResult = wait.wait(timeout: .now() + 10)
			if(timeoutResult == .timedOut){
				ao.log("timout")
				task.cancel()
				print("timeout")
			}
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
