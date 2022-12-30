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
	@State var notes: String = ""

	var body: some View {
		ZStack{
			if let p = person {
				ScrollView(showsIndicators: false){
					VStack(alignment: .leading, spacing: 20){
						VStack(alignment: .leading, spacing: 0){
							//title bar
							HStack{
								if type(of: p) == Q2er.self {
									HStack{
										Text((p as! Q2er).vorname)
										Text((p as! Q2er).nachname)
									}
								} else {
									Text(p.name)
								}
								Spacer()
								Button(action: {person = nil}, label: {
									Image(systemName: "xmark")
								}).font(.body.weight(.regular))
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




						//            .confirmationDialog(
						//                "Email versenden?",
						//                 isPresented: $formEmailConfirmationShown
						//            ) {
						//                Button("Ja, senden!") {
						//                    let mm = EmailManager()
						//                    mm.sendMail(mail: p.generateFormEmail()!)
						//                }
						//            }
						BestellungsUebersicht(p: p)
						Divider()
						ExtraFields(p: p)


						// TODO: einfügen
						//            var bestellungen: [UUID: Int]
						//            var extraFields: [String: String]
						
						Divider()
						
						VStack(spacing: 5) {
							HStack{
								Text("Notizen")
									.font(.title2.bold())
								Spacer()
							}
							
							TextEditor(text: $notes)
								.frame(height: 200)
								.border(.gray)
								.onChange(of: notes){ _ in
									p.notes = notes
								}
							
								
						}
						
						Spacer()
					}
				}
			}
		}
		.padding()
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
			ForEach(Array(p.extraFields.keys).sorted(by: {$0 < $1}), id: \.self) { item in
				Text("\(item): \(p.extraFields[item] ?? "????")")
			}
		}
	}
}
