//
//  Verwaltung.swift
//  
//
//  Created by Benedict on 22.12.22.
//

import Foundation

class Verwaltung: ObservableObject, Codable {
	required init(from decoder: Decoder) throws {

	}

	func encode(to encoder: Encoder) throws {
		
	}


	@Published var personen: [Person] = []
	@Published var transaktionen: [Transaktion] = []

	init() {
		
	}

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

	func verteileItems() {
		for item in Item.allCases {
			var round = 0
			var aktuell_verfuegbar = item.verfuegbar

			var personenDieWollen = personen
			while (!personenDieWollen.isEmpty && aktuell_verfuegbar > 0) {
				for person in personenDieWollen {
					person.bestellungen[item] = round
				}

				round += 1
				aktuell_verfuegbar = item.verfuegbar - personen.map({$0.bestellungen[item]!}).reduce(0, +)
				personenDieWollen = personen.filter({$0.wuenschBestellungen[item] ?? 0 > $0.bestellungen[item]!})
				personenDieWollen = Array(personenDieWollen.shuffled().prefix(upTo: min(aktuell_verfuegbar, personenDieWollen.count)))
			}
		}
	}
}
