//
//  PersonenActionView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct PersonenActionView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var selectedPersonen: [Person]
	@State var aktionObserver: AktionObserver

	//FORM
	@State var resendForm = false
	@State var unlockSendForm = false

	// Tickets
	@State var resendTicket = false
	@State var nurVollTicket = true
	@State var unlockSendTicket = false

	// Fülle
	@State var unlockFuelleTickets = false

	var body: some View {
		VStack(spacing: 20){
			Text("\(selectedPersonen.count) Personen ausgewählt")
			Button(action: {
				selectedPersonen = []
			}) {
				Text("clear")
			}

			HStack {
				Toggle("resend", isOn: $resendForm)
				Button(role: .destructive, action: {
					if unlockSendForm {
						DispatchQueue.global(qos: .default).async {
							Aktion.sendFormEmails(personen: selectedPersonen, observer: aktionObserver, resend: resendForm)
						}
						unlockSendForm = false
					} else {
						unlockSendForm = true
					}
				}) {
					Text("Send Form Email")
				}
				.unlockedStyle(unlockSendForm)
			}

			Button(role: .cancel,action: {
				if unlockFuelleTickets {
					DispatchQueue.global(qos: .default).async {
						Aktion.fuelleTickets(veraltung: verwaltung, personen: selectedPersonen, ao: aktionObserver)
					}
					unlockFuelleTickets = false
				} else {
					unlockFuelleTickets = true
				}
			}) {
				Text("Fülle Tickets")
			}
			.unlockedStyle(unlockFuelleTickets)

			HStack {
				Toggle("resend", isOn: $resendTicket)
				Toggle("nur Voll", isOn: $nurVollTicket)
				Button(role: .destructive, action: {
					if unlockSendTicket {
						DispatchQueue.global(qos: .default).async {
							Aktion.sendeTickets(personen: selectedPersonen, verwaltung: verwaltung, ao: aktionObserver, resend: resendTicket, nurVoll: nurVollTicket)
						}
						unlockSendTicket = false
					} else {
						unlockSendTicket = true
					}
				}) {
					Text("Sende Tickets")
				}
				.unlockedStyle(unlockSendTicket)
			}
		}.padding()
	}
}

extension Button {
	@ViewBuilder
	func unlockedStyle(_ condition: Bool) -> some View {
		if condition {
			buttonStyle(.borderedProminent)
		} else {
			buttonStyle(.bordered)
		}
	}
}
