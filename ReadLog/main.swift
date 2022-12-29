//
//  main.swift
//  
//
//  Created by Benedict on 29.12.22.
//

import Foundation

let logId = "2-44"

print("fetch log for \(logId)")

let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/logs/\(logId).json")!
let request = URLRequest(url: url)
let wait = DispatchGroup()
wait.enter()
let task = URLSession.shared.dataTask(with: request) { data, response, error in
	print(error ?? "")
	if let httpResponse = response as? HTTPURLResponse {
		let responseCode = httpResponse.statusCode
		print(responseCode)
		guard let data = data else { return }

		if responseCode == 200 {
			do {
				let encryptedString = Data.fromBase64((String(data: data, encoding: .utf8) ?? "").replacingOccurrences(of: "\"", with: ""))
				let decryptedData = try encryptedString?.decrypted()
				let str = String(data: decryptedData!, encoding: .utf8)
				print(">-----------------------------------------------")
				print(str ?? "could not decode")
				print("<-----------------------------------------------")

			} catch {
				print(error)
				print("fehler beim decoden")
			}
		} else {
			print("error while fetching data")
			let result = String(data: data, encoding: .utf8)!
			print(result)
		}
	}
	wait.leave()
}
task.resume()
wait.wait()

