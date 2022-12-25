//
//  PersonDetailView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonDetailView: View {
	@Binding var person: Person?
//	@State private var formEmailConfirmationShown = false
	@Binding var selectedPersonen: [Person]
	@Binding var state: AppState


	var body: some View {
		Button(action: {
			person = nil
		}) {
			Text("close")
		}
		if let p = person {
			if type(of: p) == Q2er.self {
				Text((p as! Q2er).vorname)
				Text((p as! Q2er).nachname)
			} else {
				Text(p.name)
			}
			Text(p.email ?? "keine Email hinterlegt")

			Text(p.notes)

			Button(role: .destructive, action: {
//				formEmailConfirmationShown = true
				selectedPersonen = [p]
				state = .aktionen
			}) {
				Text("Aktionen")
			}
//			.confirmationDialog(
//				"Email versenden?",
//				 isPresented: $formEmailConfirmationShown
//			) {
//				Button("Ja, senden!") {
//					let mm = EmailManager()
//					mm.sendMail(mail: p.generateFormEmail()!)
//				}
//			}

			Text("zuzahlender Betrag: \(p.zuzahlenderBetrag)")
			Text("gezahlter Betrag: \(p.gezahlterBetrag)")
			Text("offener Betrag: \(p.offenerBetrag)")

			BestellungsUebersicht(p: p)


			// TODO: einfügen
//			var bestellungen: [UUID: Int]
//			var extraFields: [String: String]
		}
	}
}

struct BestellungsUebersicht: View{
	let p: Person

	var body: some View {
		VStack {
			Text("Wünsche: ")
			ForEach(Array(p.wuenschBestellungen.keys).sorted(by: {$0.displayName < $1.displayName}), id: \.self) { item in
				Text("\(item.displayName): \(p.wuenschBestellungen[item] ?? 0)")
			}

			Text("Bestellungen(zugesichert): ")
			ForEach(Array(p.bestellungen.keys).sorted(by: {$0.displayName < $1.displayName}), id: \.self) { item in
				Text("\(item.displayName): \(p.bestellungen[item] ?? 0)")
			}
		}
	}
}
