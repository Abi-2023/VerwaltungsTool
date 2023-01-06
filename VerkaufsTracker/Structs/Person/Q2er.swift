//
//  Q2er.swift
//  
//
//  Created by Benedict on 23.12.22.
//

import Foundation
import SwiftSMTP

class Q2er: Person {

	var vorname: String
	var nachname: String
	override var name: String { get {"\(vorname) \(nachname)"} set {}}
	override var formName: String {"\(vorname) \(nachname.first ?? "?"). "}

	init(vorname: String, nachname: String, email: String?, notes: String, bestellungen: [UUID : Int], extraFields: [String : String], verwaltung: Verwaltung) {
		self.vorname = vorname
		self.nachname = nachname
		super.init(name: "", email: email, verwaltung: verwaltung)
	}

	private enum CodingKeys: String , CodingKey {case vorname, nachname}
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		vorname = try container.decode(String.self, forKey: .vorname)
		nachname = try container.decode(String.self, forKey: .nachname)
		try super.init(from: decoder)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try super.encode(to: encoder)
		try container.encode(vorname, forKey: .vorname)
		try container.encode(nachname, forKey: .nachname)
	}

	static func == (lhs: Q2er, rhs: Q2er) -> Bool {
		lhs.id == rhs.id &&
		lhs.email == rhs.email &&
		lhs.notes == rhs.notes &&
		lhs.bestellungen == rhs.bestellungen &&
		lhs.extraFields == rhs.extraFields &&
		lhs.formID == rhs.formID &&
		lhs.vorname == rhs.vorname &&
		lhs.nachname == rhs.nachname
	}


	override func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(email)
		hasher.combine(notes)
		hasher.combine(bestellungen)
		hasher.combine(extraFields)
		hasher.combine(formID)

		hasher.combine(vorname)
		hasher.combine(nachname)
	}

	override func generateFormEmail(ao: AktionObserver? = nil) -> Mail? {
		return generateFormEmailInternal(ao: ao)
	}

	func generateBezahlEmail(ao: AktionObserver? = nil) -> Mail? {
		return generateBezahlEmailInternal(ao: ao)
	}

	override func generateBezahlEmail() -> Mail? {
		return generateBezahlEmailInternal()
	}

}
