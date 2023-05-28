//
//  ScanConnector.swift
//  
//
//  Created by Benedict on 27.05.23.
//

import Foundation


struct ScannerResults {
	let id: String //Id vom Scanner
	let name: String //Name vom Scanner
	
}


class ScanConnector: ObservableObject {

	func uploadScan() {
		do {


			let url = URL(string: SECRETS.TABLE_SCANS)!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.setValue("Bearer \(SECRETS.AIRTABLE_ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
			request.httpMethod = "POST"
			request.httpBody = """
   {"records": [
   {
   "fields": {
   "ID": "\(UUID().uuidString)",
   "Device": "\(CloudStatus.deviceId())",
   "TimeStamp": "\(Date().timeIntervalSince1970)",
   "TicketId": "abcdef",
   "Aktiv": true
   }
   }
   ]
   }
   """.data(using: .utf8)

			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				print(error ?? "")
				if let httpResponse = response as? HTTPURLResponse {
					let responseCode = httpResponse.statusCode
					print(responseCode)

					if responseCode == 200 || responseCode == 204{
						print("successfully uploaded scan")
					} else {
						print("error while uploading data")
						guard let data = data else { return }
						let result = String(data: data, encoding: .utf8)!
						print(result)
					}
				}
			}
			task.resume()
		} catch {
			print(error)
			print("fehler beim cloud upload")
		}
	}
}
