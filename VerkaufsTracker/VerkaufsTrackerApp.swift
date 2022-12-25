//
//  VerkaufsTrackerApp.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI

enum AppState {
	case personenView, stats, aktionen, debug
}

@main
struct VerkaufsTrackerApp: App {
	@State var verwaltung = Verwaltung()
	@State var state: AppState = .personenView

	var body: some Scene {
		WindowGroup {
			GeometryReader { reader in
				VStack{
					switch state {
					case .personenView:
						PersonenView(verwaltung: verwaltung)
					case .debug:
						ContentView(verwaltung: verwaltung)
					default:
						ContentView(verwaltung: verwaltung)
					}
					Spacer()
					Navbar(appState: $state, width: reader.size.width)
				}.onAppear {
					let person = Q2er(vorname: "Benedict", nachname: "***REMOVED***", email: "***REMOVED***", notes: "", bestellungen: [:], extraFields: [:], verwaltung: verwaltung)
					person.wuenschBestellungen[.ball_ticket] = 400;
					let person2 = Q2er(vorname: "***REMOVED***", nachname: "***REMOVED***", email: "***REMOVED***", notes: "", bestellungen: [:], extraFields: [:], verwaltung: verwaltung)
					person2.wuenschBestellungen[.ball_ticket] = 400;
					verwaltung.personen.append(person)
					verwaltung.personen.append(person2)
				}
			}
		}
	}
}
