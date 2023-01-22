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


//			Button(action: {
//				let str =  Ticket(owner: Person(name: "Benedict", email: "***REMOVED***", verwaltung: Verwaltung()), type: .after_show_ticket, nth: 1, verwaltung: verwaltung).ticketHTML(verwaltung: verwaltung)
//				let renderer = CustomPrintPageRenderer()
//				renderer.exportHTMLContentToPDF(HTMLContent: str)
//			}) {
//				Text("render ticket")
//			}


			Button(action: {
				let export = PersonenExport(v: verwaltung)
				export.speicher()
			}) {
				Text("SpeicherMap")
			}

			Button(action: {
				//			let m = verwaltung.personen.first(where: {$0.name.contains("Benedict")})!.generateBezahlEmail()
				//			let sender = EmailManager()
				//			sender.sendMail(mail: m!)
			}) {
				Text("Button1")
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
