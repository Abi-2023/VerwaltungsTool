//
//  Aktion_VerteileTickets.swift
//  
//
//  Created by Benedict on 29.12.22.
//

import Foundation

extension Aktion {
	static let ticketTypen: [Item] = [.ball_ticket, .after_show_ticket]

	public static func fuelleTickets(veraltung v: Verwaltung, personen: [Person], ao: AktionObserver, unbezahlte: Bool = false) {
		ao.activate()
		ao.setPrompt("Fülle Tickets")
		var i = 0
		ao.log("fülle tickets")
		for person in personen {
			if person.offenerBetrag(v: v) < 0 || unbezahlte {
				// Person hat bezahlt
				for itemType in Aktion.ticketTypen {
					let anzahlTickets = person.tickets.filter({$0.itemType == itemType}).count
					let diff = person.bestellungen[itemType, default: 0] - anzahlTickets
					if diff > 0 {
						for n in (anzahlTickets..<person.bestellungen[itemType, default: 0]) {
							person.tickets.append(Ticket(owner: person, type: itemType, nth: n+1))
						}
						ao.log("Für \(person.name) \(diff) Tickets \(itemType) hinzugefügt")
						i += diff
					} else if diff < 0 {
						ao.log("ERR: \(person.name) hat zu viele Tickets vom Typ \(itemType)")
						continue
					} else {
					}
				}
			} else {
				ao.log("\(person.name) hat noch nicht bezahlt")
			}
		}

		ao.log("\(i) tickets aufgefüllt")
		ao.finish()
	}

}
