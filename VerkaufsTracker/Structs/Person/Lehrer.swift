//
//  Lehrer.swift
//  
//
//  Created by Benedict on 23.12.22.
//

import Foundation
import SwiftSMTP

class Lehrer: Person {

	let vorname: String
	let nachname: String
	let kuerzel: String
	let weiblich: Bool

	override var name: String { get {"\(vorname) \(nachname)"} set {}}
	override var formName: String {kuerzel}

	init(vorname: String, nachname: String, kuerzel: String, weiblich: Bool, v: Verwaltung) {
		self.vorname = vorname
		self.nachname = nachname
		self.kuerzel = kuerzel
		self.weiblich = weiblich
		super.init(name: "", email: "\(kuerzel)@st-anna.de", verwaltung: v)
	}

	private enum CodingKeys: String , CodingKey {case vorname, nachname, kuerzel, weiblich}
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		vorname = try container.decode(String.self, forKey: .vorname)
		nachname = try container.decode(String.self, forKey: .nachname)
		kuerzel = try container.decode(String.self, forKey: .kuerzel)
		weiblich = try container.decode(Bool.self, forKey: .weiblich)
		try super.init(from: decoder)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try super.encode(to: encoder)
		try container.encode(vorname, forKey: .vorname)
		try container.encode(nachname, forKey: .nachname)
		try container.encode(kuerzel, forKey: .kuerzel)
		try container.encode(weiblich, forKey: .weiblich)
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

	override func generateFormEmail(ao: AktionObserver? = nil) -> Mail? {
		return generateFormEmailInternal(ao: ao)
	}

	override func generateBezahlEmail(ao: AktionObserver? = nil) -> Mail? {
		return generateBezahlEmailInternal(ao: ao)
	}

	override func generateAngekommenEmail(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		return generateAngekommenEmailInternal(v: v, ao: ao)
	}

	override func generateTicketEmail(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		return generateTicketEmailInternal(v: v, ao: ao)
	}
}
