//
//  Aktion_verteileItems.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation

extension Aktion {

	// TODO: Log im ao
	static public func verteileItems(verwaltung v: Verwaltung, ao: AktionObserver) {
		ao.clear()
		ao.activate(name: "VerteileItems")
		if v.verteilungDeaktiviert && !SECRETS.TEST_MODE {
			ao.log("Deaktiviert")
			ao.finish()
			return
		}
		ao.setPrompt("VerteileItems")
		for item in Item.allCases {
			var round = 0
			var aktuell_verfuegbar = item.verfuegbar

			var personenDieWollen = v.personen
			while (!personenDieWollen.isEmpty && aktuell_verfuegbar > 0) {
				for person in personenDieWollen {
					person.bestellungen[item] = round
				}

				round += 1
				aktuell_verfuegbar = item.verfuegbar - v.personen.map({$0.bestellungen[item]!}).reduce(0, +)
				personenDieWollen = v.personen.filter({$0.wuenschBestellungen[item] ?? 0 > $0.bestellungen[item]!})

				let personenDieBekommen = Array(personenDieWollen.shuffled().prefix(upTo: min(aktuell_verfuegbar, personenDieWollen.count)))
				if(aktuell_verfuegbar < personenDieWollen.count) {
					ao.log("\(item.displayName): \(personenDieWollen.count - aktuell_verfuegbar) Personen bekommen weniger als sie wollen -> unter \(round)")
					ao.log("nur noch \(aktuell_verfuegbar) items vorhanden")

					ao.log("Bekommen:")
					for person in personenDieBekommen {
						ao.log("\(person.name) \(round) / \(person.wuenschBestellungen[item, default: 0])")
					}

					ao.log("/n--------\nNicht Bekommen:")
					for person in Array(Set(personenDieWollen).subtracting(personenDieBekommen)).sorted(by: {$0.name < $1.name}) {
						ao.log("\(person.name) \(round - 1) / \(person.wuenschBestellungen[item, default: 0])")
					}
				}
				personenDieWollen = personenDieBekommen
			}
			ao.log("\(item.displayName): max round: \(round - 1)")
			ao.log("Wunsch: \(v.personen.map({$0.wuenschBestellungen[item, default: 0]}).reduce(0, +))")
			ao.log("Bestellung: \(v.personen.map({$0.bestellungen[item, default: 0]}).reduce(0, +))")
			ao.log("Kapazität: \(item.verfuegbar)")
			ao.log("--------")
		}
		v.verteilungDeaktiviert = true
		ao.finish()
	}
}
