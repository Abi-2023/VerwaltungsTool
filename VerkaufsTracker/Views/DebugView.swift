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

				verwaltung.personen.first(where: {$0.name == "Benedict ***REMOVED***"})!.tickets.forEach { ticket in
					let str =  ticket.ticketHTML(verwaltung: v2)
					let renderer = CustomPrintPageRenderer()
					renderer.exportHTMLContentToPDF(HTMLContent: str)
				}
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
//				ScanConnector().uploadScan(ticket: <#T##Ticket#>)
			}) {
				Text("Register Scan")
			}

			Button(action: {
				let s = ScanConnector()
				s.fetchResults()
			}) {
				Text("fetchResults")
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
