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
							BestellungsUebersicht(p: p)
							Divider()
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
	}
}

struct BestellungsUebersicht: View{
	let p: Person

	var body: some View {
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
		
		Divider()
		VStack(alignment: .leading, spacing: 5) {
			HStack {
				Text("Wünsche")
					.font(.title2.bold())
				Spacer()
				Text("Nach Angabe im Google-Formular")
					.foregroundColor(.gray)
			}

			ForEach(Array(p.wuenschBestellungen.keys).sorted(by: {$0.displayName < $1.displayName}), id: \.self) { item in
				Text("\(item.displayName): \(p.wuenschBestellungen[item] ?? 0)")
			}
		}
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
