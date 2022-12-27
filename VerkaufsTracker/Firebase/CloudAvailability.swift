//
//  CloudAvailability.swift
//  
//
//  Created by Benedict on 27.12.22.
//

import Foundation

struct CloudStatus: Codable {
	var lastConnection: Date = .now
	var connectedUser: String? = CloudStatus.deviceId()

	func allowedToInteract() -> Bool {
		return connectedUser == nil || connectedUser == CloudStatus.deviceId() || abs(lastConnection.timeIntervalSinceNow) > 15*60 //15 minuten
	}

	static func deviceId() -> String{
		let defaults = UserDefaults()
		if let deviceId = defaults.string(forKey: "deviceId") {
			return deviceId
		}
		let newId = UUID().uuidString
		defaults.set(newId, forKey: "deviceId")
		return newId
	}

	static func serverStatus(completion: @escaping (CloudStatus?) -> Void){
		let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/status.json")!
		let request = URLRequest(url: url)

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			print(error ?? "")
			if let httpResponse = response as? HTTPURLResponse {
				let responseCode = httpResponse.statusCode
				print(responseCode)
				guard let data = data else { return }

				if responseCode == 200 {
					let decoder = JSONDecoder()
					do {
						let cloudStatus = try decoder.decode(CloudStatus.self, from: data)
						completion(cloudStatus)

					} catch {
						print(error)
						print("fehler beim decoden")
						return
					}
				} else {
					print("error while fetching cloud status")
					let result = String(data: data, encoding: .utf8)!
					print(result)
				}
			}
			completion(nil)
		}
		task.resume()
	}

	static func setOwnToServer() {
		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(CloudStatus())

			let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/status.json")!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpMethod = "PUT"
			let wrapper = CloudWrapper(data: data)
			request.httpBody = try encoder.encode(wrapper)

			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				print(error ?? "")
				if let httpResponse = response as? HTTPURLResponse {
					let responseCode = httpResponse.statusCode
					print(responseCode)

					if responseCode == 200 {
						print("successfullyUploadedCloudStatus")
					} else {
						print("error while updating cloudStatus")
						guard let data = data else { return }
						let result = String(data: data, encoding: .utf8)!
						print(result)
					}
				}
			}
			task.resume()
		} catch {
			print(error)
			print("fehler beim cloud status update")
		}
	}
}
