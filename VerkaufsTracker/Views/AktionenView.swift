//
//  AktionenView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct AktionenView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var selectedPersonen: [Person]
	@State var aktionObserver: AktionObserver

	@State var unlockVerteileItems = false

	var body: some View {
		VStack(spacing: 20){
			Text("Und los")
			Button(action: {
				DispatchQueue.global(qos: .default).async {
					Aktion.fetchFromGoogleForm(verwaltung: verwaltung, ao: aktionObserver)
				}
			}) {
				Text("fill out from google forms")
			}.buttonStyle(.bordered)


			Button(action: {
				DispatchQueue.global(qos: .default).async {
					Aktion.fetchTransaktionen(verwaltung: verwaltung, ao: aktionObserver)
				}
			}) {
				Text("Fetch Transaktionen")
			}.buttonStyle(.bordered)


			Button(role: .cancel,action: {
				if unlockVerteileItems {
					verwaltung.verteileItems()
					unlockVerteileItems = false
				} else {
					unlockVerteileItems = true
				}
			}) {
				Text("Verteile Items")
			}
			.unlockedStyle(unlockVerteileItems)
		}
	}
}
