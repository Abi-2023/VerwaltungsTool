//
//  CloudAvailability.swift
//  
//
//  Created by Benedict on 27.12.22.
//

import Foundation
import SwiftUI

enum CloudState: String{
	case error, disconnected, connected, denied, connecting, version
    
    var color: Color{
        switch self{
        case .error:
            return .red
        case .disconnected:
            return .gray
        case .connected:
            return .green
        case .denied:
            return .orange
        case .connecting:
            return .blue
		case .version:
			return .purple
        }
    }
    
    var stringGER: String{
        switch self{
        case .error:
            return "Fehler"
        case .disconnected:
            return "Nicht verbunden"
        case .connected:
            return "Verbunden"
        case .denied:
            return "Zugriff verwehrt"
        case .connecting:
            return "Verbinde..."
		case .version:
			return "Version nicht aktuell"
        }
    }
}

struct CloudStatus: Codable {
	var lastConnection: Date = .now
	var connectedUser: String? = CloudStatus.deviceId()
	var lastConnectionName: String? = CloudStatus.deviceName()
	var version: Int = SECRETS.VERSION

	func allowedToInteract() -> Bool {
		return version == SECRETS.VERSION && (connectedUser == nil || connectedUser == CloudStatus.deviceId() || lastConnection.timeIntervalSinceNow < -15*60 )//15 minuten
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
						return
					} catch {
						print(error)
						print("fehler beim decoden")
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

	static func setOwnToServer(active: Bool = true) {
		do {
			let encoder = JSONEncoder()
			var status = CloudStatus()
			if !active {
				status.connectedUser = nil
			}
			let data = try encoder.encode(status)

			let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/status.json?print=silent")!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpMethod = "PUT"
			request.httpBody = data

			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				print(error ?? "")
				if let httpResponse = response as? HTTPURLResponse {
					let responseCode = httpResponse.statusCode
					print(responseCode)

					if responseCode == 200 || responseCode == 204{
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

	static func deviceName() -> String? {
		let defaults = UserDefaults()
		return defaults.string(forKey: "DEV_Name")
	}

	static func setDeviceName(name: String?) {
		let defaults = UserDefaults()
		defaults.set(name, forKey: "DEV_Name")
	}
}

extension Verwaltung {
	func disconnectFromServer() {
		CloudStatus.setOwnToServer(active: false)
		cloud = .disconnected
	}
}
