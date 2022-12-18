//
//  PersonDetailView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonDetailView: View {
	@Binding var person: Person?
	@State private var formEmailConfirmationShown = false


	var body: some View {
		Button(action: {
			person = nil
		}) {
			Text("close")
		}
		if let p = person {
			Text(p.vorname)
			Text(p.nachname)
			Text(p.email ?? "keine Email hinterlegt")
			Text(p.q2 ? "in Q2" : "nicht in Q2")

			Text(p.notes)

			Button(role: .destructive, action: {
				formEmailConfirmationShown = true
			}) {
				Text("Form Email senden")
			}
			.confirmationDialog(
				"Email versenden?",
				 isPresented: $formEmailConfirmationShown
			) {
				Button("Ja, senden!") {
					let mm = EmailManager()
					mm.sendMail(mail: mm.generateFormEmail(person: p))
				}
			}
			// TODO: einfügen
//			var bestellungen: [UUID: Int]
//			var extraFields: [String: String]
		}
	}
}
