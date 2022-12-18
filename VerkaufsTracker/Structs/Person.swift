//
//  Person.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

class Person: Sync, Identifiable {
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
	var formID: String

	init(id: UUID, isSynced: Bool, lastUpdate: Date, lastServerEdit: Date, vorname: String, nachname: String, email: String?, q2: Bool, notes: String, bestellungen: [UUID : Int], extraFields: [String : String], verwaltung: Verwaltung) {
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
		self.formID = verwaltung.generateFormId()
	}
}

class Verwaltung {

	var personen: [Person] = []

	func generateFormId() -> String{
		//regex: /[ABCDEF][175963][SEFWQX][MNDQS5][W3YJ52]/
		let options = [
			["A", "B", "C", "D", "E", "F"],
			["1", "7", "5", "9", "6", "3"],
			["S", "E", "F", "W", "Q", "X"],
			["M", "N", "D", "Q", "S", "5"],
			["W", "3", "Y", "J", "5", "2"],
		]
		while true {
			let formId = options.map({$0.randomElement()!}).reduce("", +)
			if !personen.map({$0.formID}).contains(formId) {
				return formId
			}
		}
	}
}
