//
//  ContentView.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI
import SwiftSMTP

struct DebugView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var state: AppState
	@Binding var zahlungsVerarbeiter: ZahlungsVerarbeiter?
	@State var ao: AktionObserver

	var body: some View {
		VStack (spacing: 15){
			Text("Debug Optionen")
				.font(.largeTitle.weight(.heavy))


			Button(action: {
				CloudStatus.setDeviceName(name: nil)
				verwaltung.cloud = .disconnected
			}) {
				Text("Reset Name")
			}

			Divider()

			Button(action: {
				state = .dataImport
			}) {
				Text("import (Vorsicht!)")
			}


			Button(action: {
				let v2 = Verwaltung()
				let p = Person(name: "Benedict ***REMOVED***", email: "***REMOVED***", verwaltung: v2)
				v2.personen.append(p)
				let str =  Ticket(owner: p, type: .after_show_ticket, nth: 8, verwaltung: v2).ticketHTML(verwaltung: v2)
				let renderer = CustomPrintPageRenderer()
				renderer.exportHTMLContentToPDF(HTMLContent: str)
			}) {
				Text("render ticket")
			}


			Button(action: {
				let export = PersonenExport(v: verwaltung)
				export.speicher()
			}) {
				Text("SpeicherMap")
			}

			Button(action: {
				ScanConnector().uploadScan()
			}) {
				Text("Register Scan")
			}

			Button(action: {
				for item in Item.allCases {
					print("----\(item.displayName)")
					for i in (0...10) {
						print("\(i)x \(Person.preisFuerItem(item: item, count: i).geldStr)")
					}
				}
			}) {
				Text("Preise Style")
			}

#if canImport(CodeScanner)
			Button(action: {
				state = .scanner
			}) {
				Text("Scanner")
			}
#endif
		}
		.padding()
	}
}
