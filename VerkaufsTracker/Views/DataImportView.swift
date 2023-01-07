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
		}
		.padding()
	}
}


extension Aktion {
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

		let lines = data.replacingOccurrences(of: "\r\n", with: "\n").split(separator: "\n")

		var i = 0

		for line in lines {
			let lineElements = line.split(separator: ";")
			guard let name = lineElements[safe: 0] else {
				ao.log("err: \(line)")
				continue
			}
			guard let email = lineElements[safe: 1] else {
				ao.log("err: \(line)")
				continue
			}
			let person = Lehrer(name: String(name), email: String(email), verwaltung: v)
			v.personen.append(person)
			ao.log("+ \(person.name) | \(person.email ?? "-")")
			i += 1
		}

		ao.log("\(i) Personen hinzugefügt")

		ao.finish()
	}

}
