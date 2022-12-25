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
		hasher.combine(beschreibung)
		hasher.combine(person)

	}

	static func == (lhs: Transaktion, rhs: Transaktion) -> Bool {
		lhs.betrag == rhs.betrag &&
		lhs.beschreibung == rhs.beschreibung &&
		lhs.person == rhs.person
	}


	let betrag: Int
	let beschreibung: String
	unowned let person: Person

}
