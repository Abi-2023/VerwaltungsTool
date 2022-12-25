//
//  ContentView.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI
import SwiftSMTP
#if canImport(CodeScanner)
import CodeScanner
#endif

struct ContentView: View {
	@State private var isShowingScanner = false
	@State var image: UIImage?
	@State var verwaltung: Verwaltung


	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
		}
		.padding()
		.onAppear {
			let x2 = VerifyTicket()
			image = generateQRCode(from: "abc")

			print(image)
		}
		if let image2 = image {
			Image(uiImage: image2)
				.resizable()
			//				.scaleEffect(2)
			//				.foregroundColor(.blue)
			//				.background(.red)
				.scaledToFit()
		}

		Button(action: {
			let t = Ticket(owner: verwaltung.personen.first!)
			let ticketPdfData = exportTicketToPDF(ticket: t)

			let dataAttachment = Attachment(
				data: ticketPdfData,
				mime: "application/pdf",
				name: "ticket.pdf",
				// send as a standalone attachment
				inline: false
			)

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
			verwaltung.verteileItems()
		}) {
			Text("Verteile Items")
		}

#if canImport(CodeScanner)
		Button(action: {
			isShowingScanner = true
		}) {
			Text("Scan")
		}
		.sheet(isPresented: $isShowingScanner) {
			CodeScannerView(codeTypes: [.qr], completion: handleScan)
		}
		.padding()
#endif
	}
#if canImport(CodeScanner)
	func handleScan(result: Result<ScanResult, ScanError>) {
		isShowingScanner = false

		print(result)
		// more code to come
	}
#endif
}
