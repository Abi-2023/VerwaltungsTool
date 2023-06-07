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
			let tischQuoteLinkIdentifier = tische.first(where: {verwaltung.personen.first(where: {$0.id == ticket.owner})?.extraFields[.TischName] == $0.name})?.ghId ?? "404" //TODO: muss throwing sein
			return "https://abi-2023.github.io/Ticket/T/\(tischQuoteLinkIdentifier).html?x=\(ticket.id)4bne8"
		} else {
			//TODO: link für ASP Tickets
			return "http://jdh.gg/watch?v=dQw4w9WgXcQ&x=\(ticket.id)4bne8"
		}
	}

	public func getTicketFromScan(text: String) -> Ticket? {
		// TODO: "signature" überprüfen
		do {
			let regex = try NSRegularExpression(pattern: "(?!\\?x=)[ABCD1234]{3}-[ABCD1234]{3}", options: NSRegularExpression.Options.caseInsensitive)
			let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf8.count))

			if let match = matches.first {
				let range = match.range(at:0)
				if let swiftRange = Range(range, in: text) {
					let name = text[swiftRange]
					return getTicketFromCode(text: String(name))
				}
			}
		} catch {
			return nil
		}
		guard let ticketId = NSRegularExpression.getMatches(regex: "(?!\\?x=)[ABCD1234]{3}-[ABCD1234]{3}", inputText: text).first else {
			return nil
		}

		return getTicketFromCode(text: ticketId)
	}

	public func getTicketFromCode(text: String) -> Ticket? {
		return verwaltung.personen.flatMap({$0.tickets}).first(where: {$0.id == text})
	}
}


extension ScanConnector {
	/// Wenn ticket bereits eingelöst wurde, wir die uhrzeit angegeben, an der das ticket eingelöst wurde und von welchem gerät
	func ticketEingeloest(ticket: Ticket) -> (date: Date?, device: String?)? {
		guard let record = records.first(where: {$0.ticketId == ticket.id && $0.active}) else {
			return nil
		}
		return (record.timestamp, record.device)
	}
}
