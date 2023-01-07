//
//  Aktion_Valid.swift
//  
//
//  Created by Benedict on 07.01.23.
//

import Foundation

extension Aktion {
	static func valid(v: Verwaltung, ao: AktionObserver) {
		var error = false
		ao.activate(name: "Validate")
		ao.setPrompt("Finde Fehler")

		// MARK: - Pulli Größen Richtig
		for person in v.personen {
			let pulli_xs = Int(person.extraFields[.pulli_xs, default: "0"]) ?? 0
			let pulli_s = Int(person.extraFields[.pulli_s, default: "0"]) ?? 0
			let pulli_m = Int(person.extraFields[.pulli_m, default: "0"]) ?? 0
			let pulli_l = Int(person.extraFields[.pulli_l, default: "0"]) ?? 0
			let pulli_xl = Int(person.extraFields[.pulli_xl, default: "0"]) ?? 0
			let sum = pulli_xs + pulli_s + pulli_m + pulli_l + pulli_xl

			if sum != person.bestellungen[.pulli, default: 0] {
				error = true
				ao.log("Pulli Größe und Bestellung: \n\(person.name) \(sum) vs. \(person.bestellungen[.pulli, default: 0])")

			}
		}


		// MARK: - Pulli Größen Richtig
		// bestellungen <= wünsche
		// nicht zu viele bestellungen wenn unter wünsche
		for p in v.personen {
			if p.bestellungen[.pulli, default: 0] != p.wuenschBestellungen[.pulli, default: 0] {
				ao.log("!\(p.name) hat Problem bei Pullis")
				error = true
			}
			if p.bestellungen[.buch, default: 0] != p.wuenschBestellungen[.buch, default: 0] {
				ao.log("!\(p.name) hat Problem bei Büchern")
				error = true
			}

			if p.bestellungen[.ball_ticket, default: 0] > p.wuenschBestellungen[.ball_ticket, default: 0] {
				ao.log("!\(p.name) hat zu viele Balltickets")
				error = true
			}

			if p.bestellungen[.after_show_ticket, default: 0] > p.wuenschBestellungen[.after_show_ticket, default: 0] {
				ao.log("!\(p.name) hat zu viele ASP-Tickets")
				error = true
			}
		}

		if !error {
			ao.log("ohne Fehler abgeschlossen")
		}
		ao.finish()
	}
}
