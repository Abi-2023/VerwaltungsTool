//
//  Person.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation
import SwiftSMTP

class Person: Identifiable, Codable, Hashable {
	static func == (lhs: Person, rhs: Person) -> Bool {
		lhs.id == rhs.id &&
		lhs.email == rhs.email &&
		lhs.notes == rhs.notes &&
		lhs.bestellungen == rhs.bestellungen &&
		lhs.extraFields == rhs.extraFields &&
		lhs.formID == rhs.formID &&
		type(of: lhs) == type(of: rhs)
	}


	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(email)
		hasher.combine(notes)
		hasher.combine(bestellungen)
		hasher.combine(extraFields)
		hasher.combine(formID)
	}



	var id: UUID

	var email: String?
	var notes: String
	var bestellungen: [UUID: Int]
	var extraFields: [String: String]
	var formID: String
	var name: String

	init(name: String, email: String?, notes: String, bestellungen: [UUID : Int], extraFields: [String : String], verwaltung: Verwaltung) {
		self.id = UUID()
		self.name = name
		self.email = email
		self.notes = notes
		self.bestellungen = bestellungen
		self.extraFields = extraFields
		self.formID = verwaltung.generateFormId()
	}

	func generateFormEmail() -> Mail? {
		return nil
	}
}
