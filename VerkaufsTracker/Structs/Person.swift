//
//  Person.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

class Person: Sync {
	var id: UUID
	var isSynced: Bool
	var lastUpdate: Date
	var lastServerEdit: Date

	var vorname: String
	var nachname: String
	var email: String?
	var q2: Bool
	var notes: String
	var bestellungen: [UUID: Int]
	var extraFields: [String: String]

	init(id: UUID, isSynced: Bool, lastUpdate: Date, lastServerEdit: Date, vorname: String, nachname: String, email: String? = nil, q2: Bool, notes: String, bestellungen: [UUID : Int], extraFields: [String : String]) {
		self.id = id
		self.isSynced = isSynced
		self.lastUpdate = lastUpdate
		self.lastServerEdit = lastServerEdit
		self.vorname = vorname
		self.nachname = nachname
		self.email = email
		self.q2 = q2
		self.notes = notes
		self.bestellungen = bestellungen
		self.extraFields = extraFields
	}
}
