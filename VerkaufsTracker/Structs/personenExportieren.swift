//
//  personenExportieren.swift
//  
//
//  Created by Benedict on 16.01.23.
//

import Foundation

struct PersonenExport: Codable {
	fileprivate var personen: [Person]

	fileprivate struct Person: Identifiable, Equatable, Codable{
		static func == (lhs: Person, rhs: Person) -> Bool {
			lhs.id == rhs.id
		}

		let id: String
		let name: String
		var tickets: Int
		var wuensche: [String]

		init(id: String, name: String, tickets: Int) {
			self.id = id
			self.name = name
			self.tickets = tickets
			wuensche = []
		}
	}

	init(v: Verwaltung) {
		self.personen = []
		for person in v.personen {
			let tickets = person.bestellungen[.ball_ticket, default: 0]//tickets.filter({$0.itemType == .ball_ticket}).count
//			if(tickets != person.bestellungen[.ball_ticket, default: 0]) {
//				fatalError("Für: \(person.name) wurden noch nicht alle bestellten Tickets generiert")
//			}
			if tickets > 0 {
				self.personen.append(Person(id: person.formID, name: person.name, tickets: tickets))
			}
		}
	}

	func speicher() {
		do {
			let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.appendingPathComponent("PersonenMap.json")
			let encoder = JSONEncoder()

			let data = try encoder.encode(self)
			try! data.write(to: url)
		} catch {
			print("fehler beim speichern")
		}
	}
}
