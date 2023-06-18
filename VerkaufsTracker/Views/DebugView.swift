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
	@State var externerName: String = ""
	@State var externNth: Int = 1
	@State var refreshId = UUID()

	var body: some View {
		VStack (spacing: 15){
			Text("Debug Optionen")
				.font(.largeTitle.weight(.heavy))

			VStack {
				Text("ASP Tickets von Externen")
					.font(.title2.bold())

				let externePerson = verwaltung.personen.first(where: {$0.formID == "E7EN5"})!
				HStack {
					TextField("Name", text: $externerName)
						.textFieldStyle(.roundedBorder)

					Stepper("Nummer: \(externNth)", value: $externNth, in: 1...10, step: 1)

					Button(action: {
						externePerson.name = externerName
						let ticket = Ticket(owner: externePerson, type: .after_show_ticket, nth: externNth, verwaltung: verwaltung)
						let str =  ticket.ticketHTML(verwaltung: verwaltung)
						let renderer = CustomPrintPageRenderer()
						renderer.exportHTMLContentToPDF(HTMLContent: str)
						externePerson.tickets.append(ticket)
						externePerson.formID = "E7EN5"
						externePerson.name = "Externe"
						externePerson.notes += "\n \(ticket.itemType.displayName) für \(externerName) generiert: \(ticket.id)"
						verwaltung.uploadToCloud()
						refreshId = UUID()
					}) {
						Text("Speichern")
					}.buttonStyle(.bordered)
				}

				Text("Info: GenerierteTickets: \(externePerson.tickets.count)")
				Text(externePerson.notes)

				Divider()
			}.padding(20)


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
				for tisch in tische.shuffled() {
					print(verwaltung.personenAnTisch(name: tisch.name).map({$0.name}))
				}
			}) {
				Text("Tischplan")
			}

			Button(action: {
				let s = ScanConnector()
				s.fetchResults()
			}) {
				Text("fetchResults")
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
		.id(refreshId)
	}
}
