//
//  VerkaufsTrackerApp.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI

enum AppState {
	case personenView, debug
}

@main
struct VerkaufsTrackerApp: App {
	@State var verwaltung = Verwaltung()
	@State var state: AppState = .personenView

	var body: some Scene {
		WindowGroup {
			VStack{
				switch state {
				case .personenView:
					PersonenView(verwaltung: verwaltung)
				case .debug:
					ContentView(verwaltung: verwaltung)
				}
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						state = .personenView
					}) {
						Text("P")
					}.buttonStyle(.bordered)
					Spacer()
					Button(action: {
						state = .debug
					}) {
						Text("D")
					}.buttonStyle(.bordered)
					Spacer()
				}
			}.onAppear {
				let person = Person(id: UUID(), vorname: "Benedict", nachname: "***REMOVED***", email: "***REMOVED***", q2: true, notes: "", bestellungen: [:], extraFields: [:], verwaltung: verwaltung)
				let person2 = Person(id: UUID(), vorname: "***REMOVED***", nachname: "***REMOVED***", email: "***REMOVED***", q2: true, notes: "", bestellungen: [:], extraFields: [:], verwaltung: verwaltung)
				verwaltung.personen.append(person)
				verwaltung.personen.append(person2)
			}
		}
	}
}
