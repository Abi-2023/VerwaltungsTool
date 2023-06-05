//
//  DataImportView.swift
//  
//
//  Created by Benedict on 07.01.23.
//

import SwiftUI

struct DataImportView: View {
	@ObservedObject var v: Verwaltung
	@Binding var state: AppState
	let ao: AktionObserver

	@State var text = ""
	var body: some View {
		VStack {
			Text("Import")
			Button(action: {
				state = .debug
			}) {
				Text("Fertig")
			}

			TextEditor(text: $text)
				.border(.gray)
				.padding()

			Button(action: {
				DispatchQueue.global(qos: .default).async {
					Aktion.importQ2er(v: v, ao: ao, data: text)
				}
			}) {
				Text("Import Q2er")
			}
			
			Button(action: {
				DispatchQueue.global(qos: .default).async {
					Aktion.importLehrer(v: v, ao: ao, data: text)
				}
			}) {
				Text("Import Lehrer")
			}

			Button(action: {
				DispatchQueue.global(qos: .default).async {
					Aktion.importTischplan(v: v, ao: ao, data: text)
				}
			}) {
				Text("Import Tischplan")
			}
		}
		.padding()
	}
}


extension Aktion {
	static func importTischplan(v: Verwaltung, ao: AktionObserver, data: String) {
		ao.activate(name: "Import Tischplan")
		ao.log("start Import")
		ao.setPrompt("Import")

		for x in data.split(separator: ";") {
			let data = x.split(separator: "$")
			guard let p = v.personen.first(where: {$0.formID == data[0]}) else {
				ao.log("person nicht gefunden: \(data[0])")
				continue
			}
			guard let t = tische.first(where: {$0.buchstabe == data[1]}) else {
				ao.log("tisch nicht gefunden: \(data[1])")
				continue
			}
			p.extraFields[.TischName] = t.name
		}

		ao.finish()
	}

	static func importQ2er(v: Verwaltung, ao: AktionObserver, data: String) {
		ao.activate(name: "Import Q2er")
		ao.log("start Import")
		ao.setPrompt("Import")

		let lines = data.replacingOccurrences(of: "\r\n", with: "\n").split(separator: "\n")

		var i = 0

		for line in lines {
			let lineElements = line.split(separator: ";")
			guard let vorname = lineElements[safe: 0] else {
				ao.log("err: \(line)")
				continue
			}
			guard let nachname = lineElements[safe: 1] else {
				ao.log("err: \(line)")
				continue
			}
			guard let email = lineElements[safe: 2] else {
				ao.log("err: \(line)")
				continue
			}
			let person = Q2er(vorname: String(vorname), nachname: String(nachname), email: String(email), notes: "", bestellungen: [:], extraFields: [:], verwaltung: v)
			v.personen.append(person)
			ao.log("+ \(person.name) | \(person.email ?? "-")")
			i += 1
		}

		ao.log("\(i) Personen hinzugefügt")

		ao.finish()
	}


	static func importLehrer(v: Verwaltung, ao: AktionObserver, data: String) {
		ao.activate(name: "Import Lehrer")
		ao.log("start Import")
		ao.setPrompt("Import")

		let lines = data.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n").split(separator: "\n")

		var i = 0

		for line in lines {
			let lineElements = line.split(separator: ";")
			guard let kuerzel = lineElements[safe: 0] else {
				ao.log("err: \(line)")
				continue
			}
			guard let vorname = lineElements[safe: 2] else {
				ao.log("err: \(line)")
				continue
			}
			guard let nachname = lineElements[safe: 1] else {
				ao.log("err: \(line)")
				continue
			}
			guard let geschlecht = lineElements[safe: 3] else {
				ao.log("err: \(line)")
				continue
			}

			let weiblich: Bool;
			if geschlecht == "w" {
				weiblich = true
			} else if geschlecht == "m" {
				weiblich = false
			} else {
				return
			}

			let person = Lehrer(vorname: String(vorname), nachname: String(nachname), kuerzel: String(kuerzel), weiblich: weiblich, v: v)
			v.personen.append(person)
			ao.log("+ \(person.name) | \(person.email ?? "-")")
			i += 1
		}

		ao.log("\(i) Personen hinzugefügt")

		ao.finish()
	}

}
