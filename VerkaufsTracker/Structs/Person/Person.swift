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
	var bestellungen: [Item: Int]
	var extraFields: [String: String]
	var formID: String
	var name: String

	var gezahlterBetrag: Int {
		return verwaltung.transaktionen.filter({$0.personId == self.id}).map({$0.betrag}).reduce(0, +)
	}

	var zuzahlenderBetrag: Int {
		var tmpBetrag = 0
		for item in bestellungen {
			tmpBetrag += item.key.preis * item.value
		}
		return tmpBetrag
	}

	var offenerBetrag: Int {
		return zuzahlenderBetrag - gezahlterBetrag
	}

	unowned let verwaltung: Verwaltung

	var searchableText: String {
		var str = email ?? ""
		str += notes
		str += formID
		str += name
		str = str.uppercased()
		return str
	}

	init(name: String, email: String?, verwaltung: Verwaltung) {
		self.id = UUID()
		self.name = name
		self.email = email
		self.notes = ""
		self.bestellungen = [:]
		self.extraFields = [:]
		self.formID = verwaltung.generateFormId()
		self.verwaltung = verwaltung
	}

	func generateFormEmail() -> Mail? {
		return nil
	}
}
