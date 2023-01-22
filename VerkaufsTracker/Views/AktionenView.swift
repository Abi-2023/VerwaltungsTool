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
	@Binding var zahlungsVerarbeiter: ZahlungsVerarbeiter?
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
				Button(role: .destructive,action: {
					if unlockVerteileItems {
						DispatchQueue.global(qos: .default).async {
							Aktion.verteileItems(verwaltung: verwaltung, ao: aktionObserver)
						}
						unlockVerteileItems = false
					} else {
						unlockVerteileItems = true
					}
				}) {
					Text("Verteile Items")
				}
				.unlockedStyle(unlockVerteileItems)
				.disabled(true)
				Spacer()
			}

			HStack {
#if targetEnvironment(macCatalyst)
				Button(action: {
					zahlungsVerarbeiter = ZahlungsVerarbeiter(v: verwaltung, ao: aktionObserver)
				}) {
					Text("Zahlung Importieren")
				}.buttonStyle(.bordered)
#endif
				Spacer()
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


			Divider()
			
			HStack{
				Button(role: .cancel,action: {
					DispatchQueue.global(qos: .default).async {
						Aktion.valid(v: verwaltung, ao: aktionObserver)
					}
				}) {
					Text("Prüfe auf Fehler")
				}.buttonStyle(.bordered)
				Spacer()
			}
		}.padding()
	}
}
