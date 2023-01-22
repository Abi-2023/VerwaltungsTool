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
							throw MyError.runtimeError("keine Datei ausgewählt")
						}

						let data = try Data(contentsOf: file)
						guard let fileStr = String(data: data, encoding: .utf8) else {
							throw MyError.runtimeError("Datei konnte nicht gelesen werden")
						}
						zahlungsVerarbeiter.verarbeiteCSV(str: fileStr)

					} catch {
						print("error: \(error)")
					}

				}
			} else {
				// MARK: - Personnen auswählen
				Button(action: {
					zahlungsVerarbeiter.fertig()
					zahlungsVerarbeiterBind = nil
				}) {
					Text("Fertig")
				}
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
								Text("keine person")
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
							Text("Ignoriern")
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
					Text("keine weiteren Einträge")
				}

			}
		}.padding()
	}
}
