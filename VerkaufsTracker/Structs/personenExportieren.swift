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
			//TODO: tickets = person.tickets.filter({$0.itemType == .ball_ticket}).count
			self.personen.append(Person(id: person.formID, name: person.name, tickets: Int.random(in: (1...9))))
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
