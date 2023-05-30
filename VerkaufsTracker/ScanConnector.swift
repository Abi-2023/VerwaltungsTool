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

	private func newRecordID() -> String {
		var tmp = ""
		while tmp == "" || records.contains(where: {$0.id == tmp}) {
			tmp = ""
			for _ in 0..<6 {
				let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".map{String($0)}
				tmp += chars.randomElement()!
			}
		}
		return tmp
	}

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
   "ID": "\(newRecordID())",
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

	@Published var records: [ScanRecord] = []

	func fetchResults(offset: String? = nil) {
		let offsetParameter = offset == nil ? "" : "?offset=\(offset!)"
		let url = URL(string: SECRETS.TABLE_SCANS + offsetParameter)!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("Bearer \(SECRETS.AIRTABLE_ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
		request.httpMethod = "GET"
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			print(error ?? "")
			if let httpResponse = response as? HTTPURLResponse {
				let responseCode = httpResponse.statusCode
				print(responseCode)

				if data != nil && (responseCode == 200 || responseCode == 204){
//					print(String(data: data!, encoding: .utf8) ?? "????")
					let decoder = JSONDecoder()
					do {
						let result = try decoder.decode(AirTableScanList.self, from: data!)
						DispatchQueue.main.async {
							for r in result.records ?? [] {
								self.records.append(ScanRecord(record: r))
							}
						}
						if let newOffset = result.offset {
							self.fetchResults(offset: newOffset)
						}
					} catch {
						print(error)
						print("fehler beim cloud upload")
					}
				} else {
					print("error while uploading data")
					guard let data = data else { return }
					let result = String(data: data, encoding: .utf8)!
					print(result)
				}
			}
		}
		task.resume()
	}
}

struct ScanRecord {
	let id: String
	let device: String
	let timestamp: Date
	let ticketId: String
	let active: Bool

	init(record: Records) {
		id = record.id ?? "?"
		device = record.fields?.Device ?? "?"
		timestamp = Date(timeIntervalSince1970: Double(record.fields?.TimeStamp ?? "0") ?? 0)
		ticketId = record.fields?.TicketId ?? "?"
		active = record.fields?.Aktiv ?? false
	}
}
