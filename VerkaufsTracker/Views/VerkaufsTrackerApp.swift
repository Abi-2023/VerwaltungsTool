//
//  VerkaufsTrackerApp.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI

enum AppState {
	case personenView, stats, aktionen, debug, scanner, dataImport
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
	@State var zahlungsVerarbeiter: ZahlungsVerarbeiter? = nil

	var body: some Scene {
		WindowGroup {
			GeometryReader { reader in
				VStack{
					if verwaltung.cloud != .connected {
						CloudView(v: verwaltung, state: $state)
					}else if aktionObserver.aktiv{
						AktionLogView(ao: aktionObserver)

						if let zahlungsVerarbeiter {
							Divider()
							ZahlungsImportOptionen(zahlungsVerarbeiter: zahlungsVerarbeiter, zahlungsVerarbeiterBind: $zahlungsVerarbeiter)
								.padding()
						}

					} else if state == .scanner{
#if canImport(CodeScanner)
						ScannerView(verwaltung: verwaltung, state: $state)
#else
						Text("scanner nicht verfügbar")
#endif
					} else if state == .dataImport{
						DataImportView(v: verwaltung, state: $state, ao: aktionObserver)
					} else {
						switch state {
						case .personenView:
							PersonenView(verwaltung: verwaltung, state: $state, selectMode: $selectMode, selectedPersonen: $selectedPersonen)
						case .debug:
							DebugView(verwaltung: verwaltung, state: $state,zahlungsVerarbeiter: $zahlungsVerarbeiter, ao: aktionObserver)
						case .aktionen:
							if verwaltung.scannerMode {
								VStack {
									Text("nicht verfügbar im scanner mode")
									Button(action: {
										verwaltung.cloud = .disconnected
									}) {
										Text("disconnect")
									}.buttonStyle(.bordered)
								}
							} else if selectedPersonen.isEmpty {
								AktionenView(verwaltung: verwaltung, selectedPersonen: $selectedPersonen, aktionObserver: aktionObserver, zahlungsVerarbeiter: $zahlungsVerarbeiter)
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
				}
			}
		}
	}
}
