//
//  CloudAccess.swift
//  
//
//  Created by Benedict on 22.12.22.
//

import Foundation
import CryptoKit

struct CloudWrapper: Codable {
	let data: Data
}

extension Verwaltung {

	func fetchFromCloud() {
//		let sealedBox = try! ChaChaPoly.SealedBox(combined: encryptedData)
//		let decryptedData = try! ChaChaPoly.open(sealedBox, using: key)
	}

	func uploadToCloud() {
		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(self)
			let encryptedBox = try! ChaChaPoly.seal(data, using: SECRETS.FB_EncryptionKey)
			let encryptedData = encryptedBox.ciphertext

			let url = URL(string: "\(SECRETS.FB_DB_URL)/\(SECRETS.FB_SCOPE)/test.json")!
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

					if responseCode == 200 {
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
