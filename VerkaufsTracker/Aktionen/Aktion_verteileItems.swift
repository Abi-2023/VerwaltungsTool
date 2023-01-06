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
				personenDieWollen = Array(personenDieWollen.shuffled().prefix(upTo: min(aktuell_verfuegbar, personenDieWollen.count)))
			}
		}
	}
}
