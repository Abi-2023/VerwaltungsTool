//
//  ContentView.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI
import SwiftSMTP

struct ContentView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var state: AppState


	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
		}
		.padding()
		
		
		Button(action: {
			let t = Ticket(owner: verwaltung.personen.first!, type: .ball_ticket, nth: 0)
			let dataAttachment = t.generateAttatchment(verwaltung: verwaltung)
			let mail = Mail(
				from: EmailManager.senderMail,
				to: [Mail.User(name: "Bene123", email: "***REMOVED***")],
				subject: "Check out this image and JSON file!",
				// The attachments we created earlier
				attachments: [dataAttachment]
			)
			
			let mailer = EmailManager()
			mailer.sendMail(mail: mail)
			
			
		}) {
			Text("send mail with ticket")
		}
		
		Button(action: {
			verwaltung.uploadToCloud()
		}) {
			Text("Upload")
		}
		
		Button(action: {
			verwaltung.connectToCloud()
		}) {
			Text("fetch")
		}
		
		Button(action: {
			verwaltung.disconnectFromServer()
		}) {
			Text("disconnect")
		}.padding()
		
		
		Button(action: {
			//			let str = PDFRenderer().renderTicket(ticket: Ticket(owner: Person(name: "Benedict", email: "***REMOVED***", verwaltung: Verwaltung()), type: .ball_ticket, nth: 1))
			//			let renderer = CustomPrintPageRenderer()
			//			renderer.exportHTMLContentToPDF(HTMLContent: str!)
		}) {
			Text("render ticket")
		}.padding()

		Button(action: {
			let m = verwaltung.personen.first(where: {$0.name.contains("Benedict")})!.generateBezahlEmail()
			let sender = EmailManager()
			sender.sendMail(mail: m!)
		}) {
			Text("send bezahl")
		}.padding()
		
#if canImport(CodeScanner)
		Button(action: {
			state = .scanner
		}) {
			Text("Scanner")
		}
		.padding()
#endif
	}
}
