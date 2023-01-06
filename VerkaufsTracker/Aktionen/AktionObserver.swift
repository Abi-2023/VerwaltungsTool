//
//  AktionObserver.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import Foundation

class AktionObserver: ObservableObject {

	@Published var prompt = ""
	@Published var log = ""
	@Published var aktiv = false
	@Published var finished = false
	weak var verwaltung: Verwaltung? = nil

	func log(_ message: String) {
		DispatchQueue.main.sync {
			log += "\n"
			log += "> " + message
		}
	}

	func setPrompt(_ message: String) {
		DispatchQueue.main.sync {
			prompt = message
		}
	}

	func activate(name: String) {
		DispatchQueue.main.sync {
			log += ">> \(name)\n"
			log += ">> \(Date().description(with: .current))"
			aktiv = true
		}
	}

	func deactivate() {
		DispatchQueue.main.sync {
			aktiv = false
		}
	}

	func finish() {
		if !SECRETS.AKTION_UploadLogs {
			DispatchQueue.main.sync {
				self.finished = true
			}
			return
		}

		// uploadData
		verwaltung?.logs = 1 + (verwaltung?.logs ?? 0)
		let logId = "\((verwaltung?.logs ?? -1 * 10))-\(Int.random(in: (0...99)))"
		log("----------------")
		log("Upload Log: \(logId)")

		do {
			 let data = try "\"\(log.data(using: .utf8)!.encrypted().base64EncodedString())\"".data(using: .utf8)

			let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/logs/\(logId).json?print=silent")!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpMethod = "PUT"
			request.httpBody = data
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				print(error ?? "")
				if let httpResponse = response as? HTTPURLResponse {
					let responseCode = httpResponse.statusCode
					if responseCode == 200 || responseCode == 204{
						print("\(responseCode )successfully uploaded log: \(logId)")
						self.log("Successfully uploaded log \(logId)")
					} else {
						print(">> \(responseCode) error while uploading log")
						self.log("\(responseCode) error while uploading log")
						guard let data = data else { return }
						let result = String(data: data, encoding: .utf8)!
						print(result)
					}
				}
				DispatchQueue.main.sync {
					self.finished = true
				}
			}
			task.resume()
			
		} catch {
			print(error)
			print("failed to upload aktion observer logs")
			self.log("Crash while uploading logs")
			DispatchQueue.main.sync {
				finished = true
			}
		}
	}

	func clear() {
		prompt = ""
		log = ""
		aktiv = false
		finished = false
	}

}

class Aktion {
	
}
