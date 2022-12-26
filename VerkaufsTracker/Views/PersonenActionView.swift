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

	var body: some View {
		Text("\(selectedPersonen.count) Personen ausgewählt")
		Button(action: {
			selectedPersonen = []
		}) {
			Text("clear")
		}

		Button(role: .destructive, action: {
			DispatchQueue.global(qos: .default).async {
				Aktion.sendFormEmails(personen: selectedPersonen, observer: aktionObserver)
			}
		}) {
			Text("Send Form Email")
		}
	}
}
