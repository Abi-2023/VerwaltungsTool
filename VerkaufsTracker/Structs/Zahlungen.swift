//
//  Zahlungen.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

// MARK: Alle Beträge in Cent
// 1 = 1ct
// 200 = 2€

class Transaktion: Codable, Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(betrag)
		hasher.combine(personId)

	}

	static func == (lhs: Transaktion, rhs: Transaktion) -> Bool {
		lhs.betrag == rhs.betrag &&
		lhs.personId == rhs.personId
	}


	let betrag: Int
	let personId: UUID

}
