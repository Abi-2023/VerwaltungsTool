//
//  ScannerView.swift
//  
//
//  Created by Benedict on 03.01.23.
//

#if canImport(CodeScanner)
import SwiftUI
import CodeScanner

enum ScanResult {
	case success, invalid, unsigned, error

	var colorCode: Color {
		switch self {
		case .success:
			return Color(red: 0.27, green: 0.9, blue: 0.31)
		case .invalid:
			return Color(red: 0.97, green: 0.59, blue: 0.19)
		case .unsigned:
			return Color(red: 1, green: 0.2, blue: 0.2)
		case .error:
			return Color(red: 0.67, green: 0.67, blue: 0.67)
		}
	}

	var message: String {
		switch self {
		case .success:
			return "Ticket erfolgreich"
		case .invalid:
			return "Ticket bereits eingelöst"
		case .unsigned:
			return "Ticket ungülitig"
		case .error:
			return "Es ist ein Fehler aufgetreten"
		}
	}
}

struct ScannerView: View {
	@ObservedObject var verwaltung = Verwaltung()
	@Binding var state: AppState

	@State var result: ScanResult?
	@State var ticket: Ticket?
	@State var showScanner = true

	var body: some View {
		Button(action: {
			state = .personenView
		}) {
			Text("Fertig")
		}
		if let result = result {
			Text(result.message)

			if let ticket {
				Text(ticket.id)
				Text(String(ticket.nth))
				Text(ticket.itemType.displayName)
				Text(verwaltung.personen.first(where: {$0.id == ticket.owner})?.name ?? "Unbekannt")
			}

			result.colorCode
			Button(action: {
				self.result = nil
			}){
				Text("nächster Scan")
			}
		} else {
			Text("Scanner")
			 	.sheet(isPresented: $showScanner) {
					CodeScannerView(codeTypes: [.qr]) { response in
						if case let .success(scanText) = response {
							let verifier = VerifyTicket()
							if verifier.verifyToken(token: scanText.string) {
								result = .success
								if let id = scanText.string.split(separator: "%")[safe: 0] {
									ticket = verwaltung.personen.flatMap({$0.tickets}).first(where: {$0.id == id})
								}
							} else {
								result = .unsigned
							}
						} else {
							result = .error
						}
					}
					.onDisappear {
						showScanner = true
					}
				}
		}
	}
}
#endif
