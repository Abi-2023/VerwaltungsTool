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
		GeometryReader {geo in
			ZStack{
				VStack(spacing: 30){
					Text("Aktionen").font(.largeTitle.weight(.heavy))
					
					HStack{
						if selectedPersonen.count == 1{
							Text("1 Person ausgewählt")
						} else{
							Text("\(selectedPersonen.count) Personen ausgewählt")
						}
						Spacer()
						Button(action: {
							selectedPersonen = []
						}) {
							Text("Ausgewählte Personen löschen")
						}
					}
					Divider()
					HStack(spacing: 10) {
						Toggle(isOn: $resendForm, label: {
							VStack(alignment: .leading, spacing: 10){
								Text("An: Sende an alle ungeachtet, ob jemand die Mail (Einladung zur Wunschangabe) schon bekommen hat oder nicht")
									.foregroundColor(resendForm ? .blue : .gray)
								Text("Aus: Sende nur an die Personen, die die Mail (Einladung zur Wunschangabe) noch nicht bekommen haben")
									.foregroundColor(!resendForm ? .blue : .gray)
							}
						}).frame(width: geo.size.width/10*7.5)
						Spacer()
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
							Text("Sende Formular")
						}
						.unlockedStyle(unlockSendForm)
					}
					Divider()
					
					HStack(spacing: 10) {
						VStack(alignment: .leading, spacing: 30){
							Toggle(isOn: $resendTicket, label: {
								VStack(alignment: .leading, spacing: 10){
									Text("An: Sende an alle ungeachtet, ob jemand die Mail (Tickets) schon bekommen hat oder nicht")
										.foregroundColor(resendTicket ? .blue : .gray)
									Text("Aus: Sende nur an die Personen, die die Mail (Tickets) noch nicht bekommen haben")
										.foregroundColor(!resendTicket ? .blue : .gray)
								}
							}).frame(width: geo.size.width/10*7.5)
							Divider()
							Toggle(isOn: $nurVollTicket, label: {
								VStack(alignment: .leading, spacing: 10){
									Text("An: Sende die Mail ab, nur wenn alle Tickets aufgeteilt, eingeplant und bezahlt sind")
										.foregroundColor(nurVollTicket ? .blue : .gray)
									Text("Aus: Sende die Mail ab, ungeachtet ob alle Tickets aufgeteilt, eingeplant und bezahlt sind")
										.foregroundColor(!nurVollTicket ? .blue : .gray)
								}
							}).frame(width: geo.size.width/10*7.5)
						}
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
					
					Divider()
					
					VStack(spacing: 20){
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
					}
				}
			}.padding()
		}
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
