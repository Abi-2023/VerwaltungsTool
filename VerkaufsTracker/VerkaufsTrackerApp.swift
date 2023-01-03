//
//  VerkaufsTrackerApp.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI

enum AppState {
	case personenView, stats, aktionen, debug, scanner
}

@main
struct VerkaufsTrackerApp: App {
	@ObservedObject var verwaltung = Verwaltung()
	@State var state: AppState = .personenView
	@State var selectedPersonen: [Person] = []
	@State var selectMode = false {
		didSet {
			selectedPersonen = []
		}
	}
	@ObservedObject var aktionObserver: AktionObserver = AktionObserver()

	var body: some Scene {
		WindowGroup {
			GeometryReader { reader in
				VStack{
					if verwaltung.cloud != .connected {
						CloudView(v: verwaltung)
					}else if aktionObserver.aktiv{
						AktionLogView(ao: aktionObserver)
					} else if state == .scanner{
#if canImport(CodeScanner)
						ScannerView(verwaltung: verwaltung, state: $state)
#endif
					} else {
						switch state {
						case .personenView:
							PersonenView(verwaltung: verwaltung, state: $state, selectMode: $selectMode, selectedPersonen: $selectedPersonen)
						case .debug:
							ContentView(verwaltung: verwaltung, state: $state)
						case .aktionen:
							if selectedPersonen.isEmpty {
								AktionenView(verwaltung: verwaltung, selectedPersonen: $selectedPersonen, aktionObserver: aktionObserver)
							} else {
								PersonenActionView(verwaltung: verwaltung, selectedPersonen: $selectedPersonen, aktionObserver: aktionObserver	)
							}
						case .stats:
							StatsView(verwaltung: verwaltung)
						default:
							Text("error")
						}
						Spacer()
						Navbar(appState: $state, width: reader.size.width)
					}
				}.onAppear {
					aktionObserver.verwaltung = verwaltung
//					verwaltung.cloud = .connected
//					let person = Q2er(vorname: "Benedict", nachname: "***REMOVED***", email: "***REMOVED***", notes: "", bestellungen: [:], extraFields: [:], verwaltung: verwaltung)
//					person.wuenschBestellungen[.ball_ticket] = 400;
//					let person2 = Q2er(vorname: "***REMOVED***", nachname: "***REMOVED***", email: "***REMOVED***", notes: "", bestellungen: [:], extraFields: [:], verwaltung: verwaltung)
//					person2.wuenschBestellungen[.ball_ticket] = 400;
//					verwaltung.personen.append(person)
//					verwaltung.personen.append(person2)
				}
			}
		}
	}
}
