//
//  ZahlungsImportOptionen.swift
//  
//
//  Created by Benedict on 22.01.23.
//

import SwiftUI

enum MyError: Error {
	case runtimeError(String)
}

struct ZahlungsImportOptionen: View {
	@ObservedObject var zahlungsVerarbeiter: ZahlungsVerarbeiter
	@Binding var zahlungsVerarbeiterBind: ZahlungsVerarbeiter?
	@State var showDocumentPicker = true

	var body: some View {
		VStack {
			Button(action: {
				zahlungsVerarbeiter.fertig()
				zahlungsVerarbeiterBind = nil
			}) {
				Text("Fertig")
			}
			if !zahlungsVerarbeiter.hatImportiert {
				// MARK: - Import CSV
				Button(action: {
					showDocumentPicker = true
				}) {
					Text("Wähle CSV aus")
				}
				.fileImporter(isPresented: $showDocumentPicker,
							  allowedContentTypes: [.commaSeparatedText],
							  allowsMultipleSelection: false)
				{ result in
					do {
						guard let file = try result.get().first else {
							throw MyError.runtimeError("Keine Datei ausgewählt")
						}

						let data = try Data(contentsOf: file)
						if let fileStr = String(data: data, encoding: .utf8) {
							zahlungsVerarbeiter.verarbeiteCSV(str: fileStr)
							return
						}

						if let fileStr = String(data: data, encoding: .nonLossyASCII) {
							zahlungsVerarbeiter.verarbeiteCSV(str: fileStr)
							return
						}

						if let fileStr = String(data: data, encoding: .ascii) {
							zahlungsVerarbeiter.verarbeiteCSV(str: fileStr)
							return
						}

						if let fileStr = String(data: data, encoding: .utf16) {
							zahlungsVerarbeiter.verarbeiteCSV(str: fileStr)
							return
						}

						if let fileStr = String(data: data, encoding: .unicode) {
							zahlungsVerarbeiter.verarbeiteCSV(str: fileStr)
							return
						}

						throw MyError.runtimeError("Datei konnte nicht gelesen werden")
					} catch {
						print("error: \(error)")
					}

				}
			} else {
				if let eintrag = zahlungsVerarbeiter.eintraege.first {


					Text(eintrag.kommentar)

					HStack(spacing: 30){
						VStack {
							Text("Datum: \(eintrag.datum)")
							Text("Text: \(eintrag.buchungstext)")
							Text("Zweck: \(eintrag.zweck)")
								.bold()
								.foregroundColor(.blue)
							Text("P: \(eintrag.zahlungsPerson)")
							Text("Betrag: \(eintrag.betrag)")
								.bold()
								.foregroundColor(.blue)
							Text("Info: \(eintrag.info)")
						}
						.padding()
						.border(.gray)


						VStack {
							Text("Resultat:")
								.bold()
							if let person = eintrag.erkanntePerson {
								Text("Person: \(person.name) - \(person.formID)")
									.bold()
									.foregroundColor(.blue)
							} else {
								Text("Keine Person")
									.bold()
									.foregroundColor(.blue)
							}
							Text("Betrag: \(eintrag.erkannterBetrag.geldStr)")
						}
					}

					HStack(spacing: 30){
						Button(role: .destructive,action: {
							zahlungsVerarbeiter.ignorieren()
						}) {
							Text("Ignorieren")
						}.buttonStyle(.bordered)

						Button(action: {
							zahlungsVerarbeiter.spaeter()
						}) {
							Text("Später")
						}

						Button(role: .cancel, action: {
							zahlungsVerarbeiter.hinzufuegen()
						}) {
							Text("Hinzufügen")
						}.buttonStyle(.bordered)
							.disabled(!eintrag.valid)

					}

				} else {
					Text("Keine weiteren Einträge")
				}

			}
		}.padding()
	}
}
