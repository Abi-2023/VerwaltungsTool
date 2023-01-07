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
                                Button(action: {state = .personenView}, label: {
                                    ZStack{
                                        Circle().fill(.blue)
                                            .frame(width: 30, height: 30)
                                        Image(systemName: "door.left.hand.open")
                                            .foregroundColor(.white)
                                    }
                                })
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
                            Spacer()
                            Button(action: {
                                showManual = true
                            }, label: {
                                ZStack{
                                    Capsule().fill(.blue)
                                    HStack{
                                        Image(systemName: "hand.tap.fill")
                                        Text("ID manuell eingeben").font(.title3.bold())
                                    }.foregroundColor(.white)
                                }.frame(height: 50)
                            }).sheet(isPresented: $showManual){
                                ManualIDView(v: verwaltung, result: $result, ticket: $ticket, isPresented: $showManual)
                            }
						}.padding()
					}
                    Spacer()
				}
                Spacer()
			}
        }
		
	}
}

struct ManualIDView: View{
    @Environment(\.colorScheme) var appearance
    
    let v: Verwaltung
    @Binding var result: ScanResult?
    @Binding var ticket: Ticket?
    @Binding var isPresented: Bool
    
    @State var inputLength: Int = 0
    
    @State var inputCode: [String] = ["_", "_", "_", "_", "_", "_"]
    let inputAccepted: [String] = ["A", "B", "C", "D", "1", "2", "3", "4"]
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 4)
        
    var body: some View{
        VStack{
            HStack{
                Text("ID manuell eingeben").font(.title.weight(.bold))
                Spacer()
                Button("Abbrechen"){
                    isPresented = false
                }
            }
            Spacer()
            HStack(spacing: 7.5){
                Spacer()
                ForEach(0...2, id: \.self){ i in
                    Text(inputCode[i])
                        .foregroundColor(inputCode[i] != "_" ? .blue : .gray)
                }
                Text("-").foregroundColor(.gray)
                ForEach(3...5, id: \.self){ i in
                    Text(inputCode[i])
                        .foregroundColor(inputCode[i] != "_" ? .blue : .gray)
                }
                Spacer()
            }.font(.system(size: 50).weight(.light))
            Spacer()
            LazyVGrid(columns: columns, spacing: 7.5){
                ForEach(inputAccepted, id: \.self){ letter in
                    Button(action: {
                        if inputLength <= 5{
                            inputCode[inputLength] = letter
                            inputLength += 1
                        }
                    }, label: {
                        ZStack{
                            Rectangle().fill(.clear)
                            Text(letter).font(.largeTitle)
                        }
                    })
                    .buttonStyle(.borderless)
                }.border(.gray)
            }.padding()
            
            HStack{
                Spacer()
                Button(action: {
                    if inputLength > 0{
                        inputLength -= 1
                        inputCode[inputLength] = "_"
                    }
                }, label: {
                    Image(systemName: "delete.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundColor(.red)
                })
                Spacer()
            }
            Spacer()
        }.padding()
            .onChange(of: inputCode){ _ in
                if inputLength == 6{
                    var code: String = inputCode.joined()
                    code.insert("-", at: code.index(code.startIndex, offsetBy: 3))
                    let ticketSearch = v.personen.flatMap({$0.tickets}).first(where: {$0.id == code})
                    if ticketSearch != nil{
                        ticket = ticketSearch
                        result = .success
                    }
                }
            }
    }
}

#endif
