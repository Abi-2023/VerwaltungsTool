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
	case success, invalid, redeemed, error

	var colorCode: Color {
		switch self {
		case .success:
            return .green
		case .invalid:
			return .red
		case .redeemed:
			return .orange
		case .error:
			return .red
		}
	}

	var message: String {
		switch self {
		case .success:
			return "Ticket gültig"
		case .invalid:
			return "Ticket ungültig"
		case .redeemed:
			return "Ticket bereits eingelöst"
		case .error:
			return "Es ist ein Fehler aufgetreten"
		}
	}
	
	var systemName: String{
		switch self {
		case .success:
			return "checkmark.circle"
		case .invalid:
			return "x.circle"
		case .redeemed:
			return "clock.arrow.circlepath"
		case .error:
			return "exclamationmark.circle.fill"
		}
	}
}

struct ScannerView: View {
	@Environment(\.colorScheme) var appearance
	@ObservedObject var verwaltung = Verwaltung()
	@Binding var state: AppState

	@State var result: ScanResult?
	@State var ticket: Ticket?
	@State var showScanner = true

	@State var showManual = false
	@State var manualID: String = ""
	
	var body: some View {
        GeometryReader{ geo in
			HStack{
				Spacer()
				VStack{
					Spacer()
					if let result = result {
						Text(result.message).font(.largeTitle.weight(.heavy))
							.foregroundColor(result.colorCode)
						Spacer()
						
						if let ticket {
							Text(ticket.itemType.displayName + " \(ticket.nth)").font(.title2.bold())
							Text(verwaltung.personen.first(where: {$0.id == ticket.owner})?.name ?? "Unbekannt").font(.title2.bold())
							Text("ID: " + ticket.id)
                                .padding(.top, 15)
							Spacer()
						}
						
						Image(systemName: result.systemName)
							.resizable()
							.scaledToFit()
							.foregroundColor(result.colorCode)
							.frame(width: geo.size.width/2.5)
						
						Spacer()

						Button(action: {
							withAnimation{
								self.result = nil
								self.ticket = nil
							}
						}){
							ZStack{
								Capsule()
									.fill(result.colorCode)
									.frame(width: 200, height: 50)
								Text("Nächster Scan")
									.font(.title2.bold())
									.foregroundColor(appearance == .dark ? .black : .white)
							}
						}
					} else {
						VStack{
							HStack{
								Text("Ticket-Scanner").font(.largeTitle.weight(.heavy))
								Spacer()
								Button("Verlassen"){
									state = .personenView
								}.foregroundColor(.red)
							}

							CodeScannerView(codeTypes: [.qr]) { response in
								if case let .success(scanText) = response {
									let verifier = VerifyTicket()
									if verifier.verifyToken(token: scanText.string) {
										result = .success
										if let id = scanText.string.split(separator: "%")[safe: 0] {
											ticket = verwaltung.personen.flatMap({$0.tickets}).first(where: {$0.id == id})
										}
									} else {
										result = .invalid
									}
								} else {
									result = .error
								}
							}
							.onDisappear {
								showScanner = true
							}
							
							VStack(spacing: 5){
								TextField("ID manuell eingeben", text: $manualID)
										.textFieldStyle(.roundedBorder)
										.onChange(of: manualID){ _ in
											let ticketSearch = verwaltung.personen.flatMap({$0.tickets}).first(where: {$0.id == manualID})
											if ticketSearch != nil{
												result = .success
												ticket = ticketSearch
												manualID = ""
											}
										}
							}.padding()
						}.padding()
					}
                    Spacer()
				}
                Spacer()
			}
        }
		
	}
}
#endif
