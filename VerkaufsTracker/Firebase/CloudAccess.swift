//
//  CloudAccess.swift
//  
//
//  Created by Benedict on 22.12.22.
//

import Foundation

struct CloudWrapper: Codable {
	let data: Data
}

extension Verwaltung {

	func connectToCloud() {
		CloudStatus.serverStatus(completion: { status in
			if let status {
				if status.allowedToInteract() {
					self.fetchFromCloud()
				} else {
					DispatchQueue.main.async {
						self.cloud = .denied
					}
				}
			} else {
				CloudStatus.setOwnToServer()
				DispatchQueue.main.async {
					self.cloud = .error
				}
			}
		})
	}

	fileprivate func fetchFromCloud() {

		let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/test.json")!
		let request = URLRequest(url: url)
		DispatchQueue.main.async {
			self.cloud = .connecting
		}

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			print(error ?? "")
			if let httpResponse = response as? HTTPURLResponse {
				let responseCode = httpResponse.statusCode
				print(responseCode)
				guard let data = data else { return }

				if responseCode == 200 {
					//TODO: verabeiten
					let decoder = JSONDecoder()
					do {
						let wrapper = try decoder.decode(CloudWrapper.self, from: data)
						let decryptedData = try wrapper.data.decrypted()
						let neueVerwaltung = try decoder.decode(CodableVerwaltung.self, from: decryptedData)
						print(neueVerwaltung.lastFetchForm)

						print(neueVerwaltung)
						CloudStatus.setOwnToServer()
						DispatchQueue.main.sync {
							self.personen = neueVerwaltung.personen
							self.transaktionen = neueVerwaltung.transaktionen
							self.lastFetchForm = neueVerwaltung.lastFetchForm
							self.logs = neueVerwaltung.logs
							self.lastFetchTransaktionen = neueVerwaltung.lastFetchTransaktionen
							self.cloud = .connected
							self.verteilungDeaktiviert = neueVerwaltung.verteilungDeaktiviert
							self.finalPrice = neueVerwaltung.finalPrice
						}
					} catch {
						print(error)
						print("fehler beim decoden")
						self.cloud = .error
					}
				} else {
					print("error while fetching data")
					let result = String(data: data, encoding: .utf8)!
					print(result)
				}
			}
		}
		task.resume()
	}

	func uploadToCloud() {
		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(CodableVerwaltung(verwaltung: self))
			let encryptedData = try data.encrypted()

			let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/test.json?print=silent")!
			var request = URLRequest(url: url)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpMethod = "PUT"
			let wrapper = CloudWrapper(data: encryptedData)
			request.httpBody = try encoder.encode(wrapper)

			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				print(error ?? "")
				if let httpResponse = response as? HTTPURLResponse {
					let responseCode = httpResponse.statusCode
					print(responseCode)

					if responseCode == 200 || responseCode == 204{
						print("successfully uploaded data")
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
