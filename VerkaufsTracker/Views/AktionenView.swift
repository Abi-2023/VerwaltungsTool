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
			Text("Aktionen").font(.largeTitle.weight(.heavy))
			HStack{
				Button(action: {
					DispatchQueue.global(qos: .default).async {
						Aktion.fetchFromGoogleForm(verwaltung: verwaltung, ao: aktionObserver)
					}
				}) {
					Text("Fetch Google Form")
				}.buttonStyle(.bordered)
				Spacer()
				Text("\(verwaltung.lastFetchForm.formatted(.dateTime))")
			}

			HStack{
				Button(action: {
					DispatchQueue.global(qos: .default).async {
						Aktion.fetchTransaktionen(verwaltung: verwaltung, ao: aktionObserver)
					}
				}) {
					Text("Fetch Transaktionen")
				}.buttonStyle(.bordered)
				Spacer()

				Text("\(verwaltung.lastFetchTransaktionen.formatted(.dateTime))")
			}

			Button(role: .cancel,action: {
				if unlockVerteileItems {
					Aktion.verteileItems(verwaltung: verwaltung, ao: aktionObserver)
					unlockVerteileItems = false
				} else {
					unlockVerteileItems = true
				}
			}) {
				Text("Verteile Items")
			}
			.unlockedStyle(unlockVerteileItems)
		}.padding()
	}
}
