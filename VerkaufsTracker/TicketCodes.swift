//
//  TicketCodes.swift
//  
//
//  Created by Benedict on 16.12.22.
//

import Foundation
import CryptoKit

class VerifyTicket{

	let signingKey: Curve25519.Signing.PrivateKey
	let publicKey: Curve25519.Signing.PublicKey

	init() {
		// TODO: load private key from secrets
		signingKey = Curve25519.Signing.PrivateKey() // tmp

		publicKey = signingKey.publicKey
	}

	func signatureForId(id: String) -> String {
		let dataToSign = id.data(using: .utf8)!
		let signature = try! signingKey.signature(for: dataToSign)
		return signature.base64EncodedString()
	}

	func verifyTicket(id: String, signatureBase64: String) -> Bool {
		let signature = Data(base64Encoded: signatureBase64)!
		return publicKey.isValidSignature(signature, for: id.data(using: .utf8)!)
	}

}
