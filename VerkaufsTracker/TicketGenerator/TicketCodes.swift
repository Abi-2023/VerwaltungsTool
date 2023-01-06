//
//  TicketCodes.swift
//  
//
//  Created by Benedict on 16.12.22.
//

import Foundation
import CryptoKit
//func convert<T: Collection>(_ c: T) -> String
//	where T.SubSequence.Iterator.Element == UInt8 {
//
//	let start = c.startIndex
//	let end = c.index(after: start)
//
//	// please consider handling the case where String(bytes:encoding:) returns nil.
//	return String(bytes: c[start ... end], encoding: String.Encoding.utf8)!
//}

class VerifyTicket{

	let signingKey: Curve25519.Signing.PrivateKey
	let publicKey: Curve25519.Signing.PublicKey

	init() {
		signingKey = SECRETS.SIGN_Key
		publicKey = signingKey.publicKey
	}

	private func signatureForId(id: String) -> String {
		let dataToSign = id.data(using: .utf8)!
		let signature = try! signingKey.signature(for: dataToSign)
		return signature.base64EncodedString()
	}

	private func verifySignature(id: String, signatureBase64: String) -> Bool {
		guard let signature = Data(base64Encoded: signatureBase64) else {
			return false
		}
		return publicKey.isValidSignature(signature, for: id.data(using: .utf8)!)
	}

	public func createToken(ticketId: String) -> String {
		return "\(ticketId)%\(signatureForId(id: ticketId))"
	}

	public func verifyToken(token: String) -> Bool {
		let id = token.split(separator: "%")[safe: 0]
		let signature = token.split(separator: "%")[safe: 1]

		guard let id else {
			return false
		}
		guard let signature else {
			return false
		}

		return verifySignature(id: String(id), signatureBase64: String(signature))
	}
}
