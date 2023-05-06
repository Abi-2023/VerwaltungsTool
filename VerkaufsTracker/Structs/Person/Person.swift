//
//  Person.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation
import SwiftSMTP

enum extraFields: String, Codable {
	case sendFormEmail, hatFormEingetragen, pulli_xs, pulli_s, pulli_l, pulli_m, pulli_xl, sendBezahlEmail, sendAngekommenEmail, Lied
}

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

	// was die Person gerne haben würde
	var wuenschBestellungen: [Item: Int] {
		get {
			print("Achtung Wünsche wird abgefragt")
			return bestellungen
		}

		set {
			fatalError("Wünsche sind nicht mehr änderbar")
		}
	}

	// was der Person zugesichert wurde
	var bestellungen: [Item: Int]
	var extraFields: [extraFields: String]
	var tickets: [Ticket] = []
	var formID: String
	var name: String
	var formName: String {name}

	func gezahlterBetrag(v: Verwaltung) -> Int {
		return v.transaktionen.filter({$0.personId == self.id}).map({$0.betrag}).reduce(0, +)
	}

	static func preisFuerItem(item: Item, count: Int) -> Int {
		return item.preis * count
	}

	var zuzahlenderBetrag: Int {
		var tmpBetrag = 0
		for item in bestellungen {
			tmpBetrag += Person.preisFuerItem(item: item.key, count: item.value)
		}
		return tmpBetrag
	}

	func offenerBetrag(v: Verwaltung) -> Int {
		return zuzahlenderBetrag - gezahlterBetrag(v: v)
	}

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
	}

	var mailUser: Mail.User? {
		if let email {
			return Mail.User(name: name, email: email)
		}
		return nil
	}

	func generateBezahlEmail(ao: AktionObserver? = nil) -> Mail? {
		return nil
	}

	func generateFormEmail(ao: AktionObserver? = nil) -> Mail? {
		return nil
	}

	func generateAngekommenEmail(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		return nil
	}

	func generateTicketEmail(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		return nil
	}
}
