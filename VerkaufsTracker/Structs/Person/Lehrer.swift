//
//  Lehrer.swift
//  
//
//  Created by Benedict on 23.12.22.
//

import Foundation
import SwiftSMTP

class Lehrer: Person {

	


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

	override func generateTicketEmail(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		return generateTicketEmailInternal(v: v, ao: ao)
	}
}
