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

	@State var resendForm = false
	@State var unlockSend = false

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
					if unlockSend {
						DispatchQueue.global(qos: .default).async {
							Aktion.sendFormEmails(personen: selectedPersonen, observer: aktionObserver, resend: resendForm)
						}
					} else {
						unlockSend = true
					}
				}) {
					Text("Send Form Email")
				}
				.unlockedStyle(unlockSend)
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
