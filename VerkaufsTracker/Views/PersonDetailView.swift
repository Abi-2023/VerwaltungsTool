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
			if type(of: p) == Q2er.self {
				Text((p as! Q2er).vorname)
				Text((p as! Q2er).nachname)
			} else {
				Text(p.name)
			}
			Text(p.email ?? "keine Email hinterlegt")

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
					mm.sendMail(mail: p.generateFormEmail()!)
				}
			}
			// TODO: einfügen
//			var bestellungen: [UUID: Int]
//			var extraFields: [String: String]
		}
	}
}
