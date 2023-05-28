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

//	let signingKey: Curve25519.Signing.PrivateKey
//	let publicKey: Curve25519.Signing.PublicKey
//
//	init() {
//		signingKey = SECRETS.SIGN_Key
//		publicKey = signingKey.publicKey
//	}
//
//	private func signatureForId(id: String) -> String {
//		let dataToSign = id.data(using: .utf8)!
//		let signature = try! signingKey.signature(for: dataToSign)
//		return signature.base64EncodedString()
//	}
//
//	private func verifySignature(id: String, signatureBase64: String) -> Bool {
//		guard let signature = Data(base64Encoded: signatureBase64) else {
//			return false
//		}
//		return publicKey.isValidSignature(signature, for: id.data(using: .utf8)!)
//	}

	let verwaltung: Verwaltung

	init(verwaltung: Verwaltung) {
		self.verwaltung = verwaltung
	}

	public func createToken(ticket: Ticket) -> String {
		if ticket.itemType == .ball_ticket {
			let tischQuoteLinkIdentifier = verwaltung.personen.first(where: {$0.id == ticket.owner})?.extraFields[.Tisch] ?? "404" //TODO: muss throwing sein
			return "https://abi-2023.github.io/Ticket/\(tischQuoteLinkIdentifier).html?x=\(ticket.id)4bne8"
		} else {
			//TODO: link für ASP Tickets
			return "https://abi-2023.github.io/Ticket/\("asp").html?x=\(ticket.id)4bne8"
		}
	}

	public func getTicketFromScan(text: String) -> Ticket? {
		// TODO: "signature" überprüfen
		guard let ticketId = NSRegularExpression.getMatches(regex: "(?!\\?x=)[ABCD1234]{3}-[ABCD1234]{3}", inputText: text).first else {
			return nil
		}

		return getTicketFromCode(text: ticketId)
	}

	public func getTicketFromCode(text: String) -> Ticket? {
		return verwaltung.personen.flatMap({$0.tickets}).first(where: {$0.id == text})
	}
}
