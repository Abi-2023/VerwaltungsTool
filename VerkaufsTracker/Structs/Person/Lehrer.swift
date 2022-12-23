//
//  Lehrer.swift
//  
//
//  Created by Benedict on 23.12.22.
//

import Foundation
import SwiftSMTP

class Lehrer: Person {

	var name: String

	init(name: String, email: String?, notes: String, bestellungen: [UUID : Int], extraFields: [String : String], verwaltung: Verwaltung) {
		self.name = name
		super.init(email: email, notes: notes, bestellungen: bestellungen, extraFields: extraFields, verwaltung: verwaltung)
	}

	private enum CodingKeys: String , CodingKey {case name}
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decode(String.self, forKey: .name)
		let superDecoder = try container.superDecoder()
		try super.init(from: superDecoder)
	}

	static func == (lhs: Lehrer, rhs: Lehrer) -> Bool {
		lhs.id == rhs.id &&
		lhs.email == rhs.email &&
		lhs.notes == rhs.notes &&
		lhs.bestellungen == rhs.bestellungen &&
		lhs.extraFields == rhs.extraFields &&
		lhs.formID == rhs.formID &&
		lhs.name == rhs.name
	}


	override func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(email)
		hasher.combine(notes)
		hasher.combine(bestellungen)
		hasher.combine(extraFields)
		hasher.combine(formID)

		hasher.combine(name)
	}
}
