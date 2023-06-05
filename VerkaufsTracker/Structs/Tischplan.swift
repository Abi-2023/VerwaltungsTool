//
//  Tischplan.swift
//  
//
//  Created by Benedict on 05.06.23.
//

import Foundation

// MARK: - Config


let tische: [Tisch] = [
	Tisch(name: "1", buchstabe: "A", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "2", buchstabe: "B", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "3", buchstabe: "C", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "4", buchstabe: "D", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "5", buchstabe: "E", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "6", buchstabe: "F", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "7", buchstabe: "G", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "8", buchstabe: "H", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "9", buchstabe: "I", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "10", buchstabe: "J", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "11", buchstabe: "K", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "12", buchstabe: "L", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "13", buchstabe: "M", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "14", buchstabe: "N", kapazitaet: 28, ghId: "0C4"),
	Tisch(name: "15", buchstabe: "O", kapazitaet: 24, ghId: "0C4"),
	Tisch(name: "16", buchstabe: "P", kapazitaet: 24, ghId: "0C4"),
	Tisch(name: "17", buchstabe: "Q", kapazitaet: 24, ghId: "0C4"),
	Tisch(name: "18", buchstabe: "R", kapazitaet: 26, ghId: "0C4"),
	Tisch(name: "19", buchstabe: "S", kapazitaet: 24, ghId: "0C4"),
	Tisch(name: "20", buchstabe: "T", kapazitaet: 24, ghId: "0C4"),
	Tisch(name: "21", buchstabe: "U", kapazitaet: 24, ghId: "0C4")
]


struct Tisch: Hashable {
	let name: String
	let buchstabe: String
	let kapazitaet: Int
	let ghId: String
}


extension Verwaltung {
	func zahlAnTisch(name: String) -> Int {
		personenAnTisch(name: name).map({$0.bestellungen[.ball_ticket] ?? 0}).reduce(0, +)
	}

	func personenAnTisch(name: String) -> [Person] {
		personen.filter({$0.extraFields[.TischName] ?? "aasdfjlkhaslefkjh" == name})
	}
}
