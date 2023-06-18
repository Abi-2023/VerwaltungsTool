//
//  PersonDetailView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonDetailView: View {
	let verwaltung: Verwaltung
	@Binding var person: Person?
	//	@State private var formEmailConfirmationShown = false
	@Binding var selectedPersonen: [Person]
	@Binding var state: AppState
	@State var notesTmp: String = ""
	@State var showTextSaveButton = false
	@State var refreshId = UUID()

	var body: some View {
		ZStack{
			if let p = person {
				ScrollViewReader { reader in
					ScrollView(showsIndicators: false){
						VStack(alignment: .leading, spacing: 20){
							VStack(alignment: .leading, spacing: 0){
								//title bar
                                HStack(alignment: .top){
									if type(of: p) == Q2er.self {
										HStack{
											Text((p as! Q2er).vorname)
											Text((p as! Q2er).nachname)
										}
									} else {
										Text(p.name)
									}
									Spacer()
                                    Button("Fertig"){
                                        person = nil
                                    }.font(.body.bold())
								}.font(.title.weight(.bold))


								Text(p.email ?? "Keine Email hinterlegt")
									.font(.body)
								Text("Google-Form-ID: \(p.formID)")
									.font(.body)
							}

							Button("Aktionen"){
								//formEmailConfirmationShown = true
								selectedPersonen = [p]
								state = .aktionen
								person = nil
							}

							VStack(spacing: 5){
								HStack{
									Text("Zuzahlender Betrag")
									Spacer()
									Text(p.zuzahlenderBetrag.geldStr)
										.bold()
								}

								HStack{
									Text("Gezahlter Betrag")
									Spacer()
									Text(p.gezahlterBetrag(v: verwaltung).geldStr)
										.bold()
								}

								HStack{
									Text("Offener Betrag")
									Spacer()
									Text(p.offenerBetrag(v: verwaltung).geldStr).underline()
										.bold()
										.foregroundColor(p.offenerBetrag(v: verwaltung) == 0 ? .green : p.offenerBetrag(v: verwaltung) > 0 ? .red : .orange)
								}
							}
							BestellungsUebersicht(refreshId: $refreshId, p: p, verwaltung: verwaltung)
							HStack {
								Text("Ball Plätze: \(p.ballPlaetze)")
								Spacer()
								Button(action: {
									p.extraFields[.plaetzeOverride] = String(p.ballPlaetze - 1)
									refreshId = UUID()
								}) {
									Text("-")
								}
								.padding(.trailing, 20)
								Button(action: {
									p.extraFields[.plaetzeOverride] = String(p.ballPlaetze + 1)
									refreshId = UUID()
								}) {
									Text("+")
								}
							}
							if person?.bestellungen[.ball_ticket] ?? 0 > 0 {
								TischPlanAuswahl(verwaltung: verwaltung, person: $person)
								Divider()
							}
							ExtraFields(p: p)

							Divider()

							VStack(spacing: 5) {
								HStack{
									Text("Notizen")
										.font(.title2.bold())
									Spacer()
									if showTextSaveButton {
										Button(action: {
											showTextSaveButton = false
											UIApplication.shared.endEditing()
										}) {
											Text("Fertig")
										}
									}
								}

								TextEditor(text: $notesTmp)
									.frame(height: 200)
									.border(.gray)
									.onChange(of: notesTmp){ _ in
										p.notes = notesTmp
									}
									.onTapGesture {
										DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
											reader.scrollTo("notizen", anchor: .bottom)
											showTextSaveButton = true
										}
									}
									.onAppear {
										notesTmp = p.notes
									}
									.id("notizen")

								
							}

							Spacer()
						}
					}
				}
			}
		}.padding()
			.id(refreshId)
	}
}

struct BestellungsUebersicht: View{
	@Binding var refreshId: UUID
	let p: Person
	let verwaltung: Verwaltung

	var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack{
                Text("Sendestatus")
                    .font(.title2.bold())
                Spacer()
                Text("Zum Absenden")
                    .foregroundColor(.gray)
            }
            
            ForEach(Array(Item.allCases).sorted(by: {$0.displayName < $1.displayName}), id: \.self){ type in
                Text("\(type.displayName): \(p.tickets.filter({$0.itemType == type}).count) von \(p.tickets.filter({$0.itemType == type && $0.versendet}).count)")
            }
        }
        
		Divider()
		VStack(alignment: .leading, spacing: 5){
			HStack{
				Text("Bestellungen")
					.font(.title2.bold())
				Spacer()
				Text("Nach Kalkulation der Kapazität")
					.foregroundColor(.gray)
			}
			ForEach(Array(p.bestellungen.keys).sorted(by: {$0.displayName < $1.displayName}), id: \.self) { item in
				Text("\(item.displayName): \(p.bestellungen[item] ?? 0)")
			}
		}

		HStack {
			Button(action: {
				p.bestellungen[.ball_ticket, default: 0] += 1
				p.notes += "Ball hinzugefügt\n"
				refreshId = UUID()
				verwaltung.uploadToCloud()
			}) {
				Text("Ball +1")
			}
			.disabled(true)
			Button(action: {
				p.bestellungen[.ball_ticket, default: 0] -= 1
				p.notes += "Ball entfernt\n"
				refreshId = UUID()
				verwaltung.uploadToCloud()
			}) {
				Text("Ball -1")
			}
			.disabled(true)
			Spacer()
			Button(action: {
				p.bestellungen[.after_show_ticket, default: 0] += 1
				p.notes += "ASP hinzugefügt\n"
				refreshId = UUID()
				verwaltung.uploadToCloud()
			}) {
				Text("ASP +1")
			}
			.disabled(verwaltung.scannerMode ? true : false)
			Button(action: {
				p.bestellungen[.after_show_ticket, default: 0] -= 1
				p.notes += "ASP entfernt\n"
				refreshId = UUID()
				verwaltung.uploadToCloud()
				
			}) {
				Text("ASP -1")
			}
			.disabled(verwaltung.scannerMode ? true : false)

		}.buttonStyle(.bordered)


		Divider()
	}
}


struct ExtraFields: View{
	let p: Person

	var body: some View {
		VStack(alignment: .leading, spacing: 5) {
			HStack{
				Text("Sonstiges")
					.font(.title2.bold())
				Spacer()
			}
			ForEach(Array(p.extraFields.keys).sorted(by: {$0.rawValue < $1.rawValue}), id: \.self) { item in
				Text("\(item.rawValue): \(p.extraFields[item] ?? "????")")
			}
		}
	}
}

//            .confirmationDialog(
//                "Email versenden?",
//                 isPresented: $formEmailConfirmationShown
//            ) {
//                Button("Ja, senden!") {
//                    let mm = EmailManager()
//                    mm.sendMail(mail: p.generateFormEmail()!)
//                }
//            }


private struct TischPlanAuswahl: View {
	let verwaltung: Verwaltung
	@Binding var person: Person?

	@State var gridLayout: [GridItem] = [ GridItem(), GridItem(), GridItem() ]
	@State var refreshId = UUID()

	var body: some View {
		VStack {
			let aktTisch = tische.first(where: {$0.name == person?.extraFields[.TischName]})
			Text("Tisch: \(person?.extraFields[.TischName] ?? "Ohne Zuordnung") (\(verwaltung.zahlAnTisch(name: aktTisch?.name ?? ""))/\(aktTisch?.kapazitaet ?? 0))")
				.font(.title2.bold())
			
			Divider()
				ForEach(verwaltung.personenAnTisch(name: person?.extraFields[.TischName] ?? ""), id: \.self) { p in
					Text("\(p.name): \(p.bestellungen[.ball_ticket] ?? 0)")
				}
			Divider()

			LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {

				ForEach(tische, id: \.self) { tisch in

					Button(action: {
						if person?.extraFields[.TischName] ?? "" == "" {
							person?.extraFields[.TischName] = tisch.name
							refreshId = UUID()
							verwaltung.uploadToCloud()
						} else {
							person?.extraFields[.TischName] = nil
							refreshId = UUID()
							verwaltung.uploadToCloud()
						}
					}) {
						Text("\(tisch.name)\(tisch.buchstabe) (\(verwaltung.zahlAnTisch(name: tisch.name))/\(tisch.kapazitaet))")
							.underline(person?.extraFields[.TischName] ?? "" == tisch.name)
							.font(person?.extraFields[.TischName] ?? "" == tisch.name ? .body.bold() : .body)
							.foregroundColor(person?.extraFields[.TischName] ?? "" == tisch.name ? .pink : .accentColor)
					}
					.disabled(verwaltung.scannerMode || ((tisch.kapazitaet - verwaltung.zahlAnTisch(name: tisch.name)) < person?.bestellungen[.ball_ticket] ?? 0 && person?.extraFields[.TischName] != tisch.name))
					.buttonStyle(.bordered)

				}
			}
			.padding(.all, 10)
		}
		.id(refreshId)
	}
}
