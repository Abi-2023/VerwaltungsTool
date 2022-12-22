//
//  Person.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

class Person: Identifiable {
	var id: UUID

	var vorname: String
	var nachname: String
	var email: String?
	var q2: Bool
	var notes: String
	var bestellungen: [UUID: Int]
	var extraFields: [String: String]
	var formID: String

	init(id: UUID, vorname: String, nachname: String, email: String?, q2: Bool, notes: String, bestellungen: [UUID : Int], extraFields: [String : String], verwaltung: Verwaltung) {
		self.id = id
		self.vorname = vorname
		self.nachname = nachname
		self.email = email
		self.q2 = q2
		self.notes = notes
		self.bestellungen = bestellungen
		self.extraFields = extraFields
		self.formID = verwaltung.generateFormId()
	}
}
