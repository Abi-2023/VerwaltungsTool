//
//  Crypto.swift
//  
//
//  Created by Benedict on 29.12.22.
//

import Foundation
import CryptoKit

extension Data {

	func decrypted() throws -> Data {
		let sealedBox = try ChaChaPoly.SealedBox(combined: self)
		return try ChaChaPoly.open(sealedBox, using: SECRETS.FB_EncryptionKey)
	}

	func encrypted() throws -> Data {
		let encryptedBox = try ChaChaPoly.seal(self, using: SECRETS.FB_EncryptionKey)
		return encryptedBox.combined
	}

}
