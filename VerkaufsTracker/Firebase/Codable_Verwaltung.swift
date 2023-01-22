//
//  Codable_Verwaltung.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation

struct PersonenWrapper: Codable{
	var andere: [Person] = []
	var q2er: [Q2er] = []
	var lehrer: [Lehrer] = []
}

class CodableVerwaltung: Verwaltung, Codable {
	enum CodingKeys: CodingKey { case personenWrapper, transaktionen, lastFetchForm, lastFetchTransaktionen, logs, finalPrice, verteilungDeaktiviert, verarbeiteteZahlungenHashs}

	init(verwaltung: Verwaltung) {
		super.init()
		self.personen = verwaltung.personen
		self.transaktionen = verwaltung.transaktionen
		self.lastFetchForm = verwaltung.lastFetchForm
		self.logs = verwaltung.logs
		self.lastFetchTransaktionen = verwaltung.lastFetchTransaktionen
		self.verarbeiteteZahlungenHashs = verwaltung.verarbeiteteZahlungenHashs
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let wrapper = try container.decode(PersonenWrapper.self, forKey: .personenWrapper)
		super.init()
		personen = wrapper.andere + wrapper.lehrer + wrapper.q2er
		transaktionen = try container.decode(type(of: transaktionen), forKey: .transaktionen)

		self.logs = try container.decode(Int.self, forKey: .logs)
		self.lastFetchForm = try container.decode(type(of: lastFetchForm), forKey: .lastFetchForm)
		self.lastFetchTransaktionen = try container.decode(type(of: lastFetchTransaktionen), forKey: .lastFetchTransaktionen)

		self.verteilungDeaktiviert = try container.decode(type(of: verteilungDeaktiviert), forKey: .verteilungDeaktiviert)
		self.finalPrice = try container.decode(type(of: finalPrice), forKey: .finalPrice)
		self.verarbeiteteZahlungenHashs = try container.decode(type(of: verarbeiteteZahlungenHashs), forKey: .verarbeiteteZahlungenHashs)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		var wrapper = PersonenWrapper()

		for person in personen {
			switch person {
			case is Q2er:
				wrapper.q2er.append(person as! Q2er)
			case is Lehrer:
				wrapper.lehrer.append(person as! Lehrer)
			default:
				wrapper.andere.append(person)
			}
		}

		try container.encode(wrapper, forKey: .personenWrapper)
		try container.encode(transaktionen, forKey: .transaktionen)
		try container.encode(lastFetchForm, forKey: .lastFetchForm)
		try container.encode(finalPrice, forKey: .finalPrice)
		try container.encode(verteilungDeaktiviert, forKey: .verteilungDeaktiviert)
		try container.encode(lastFetchTransaktionen, forKey: .lastFetchTransaktionen)
		try container.encode(logs, forKey: .logs)
		try container.encode(verarbeiteteZahlungenHashs, forKey: .verarbeiteteZahlungenHashs)
	}
}
