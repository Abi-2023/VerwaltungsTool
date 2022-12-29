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

	var body: some View {
        ZStack{
            if let p = person {
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
                            Button(role: .destructive, action: {
                                //formEmailConfirmationShown = true
                                selectedPersonen = [p]
                                state = .aktionen
                            }) {
                                Text("Aktionen").font(.body.weight(.regular))
                            }
                            Button(action: {person = nil}, label: {
                                Image(systemName: "xmark")
                            }).font(.body.weight(.regular))
                        }.font(.title.weight(.bold))
                        
                        
                        Text(p.email ?? "Keine Email hinterlegt")
                            .font(.headline)
                        Text("Google-Form-ID: \(p.formID)")
                            .font(.headline)
                    }
                    
                    VStack(spacing: 5){
                        HStack{
                            Text("Zuzahlender Betrag:")
                            Spacer()
                            Text(p.zuzahlenderBetrag.formatted(.currency(code: "EUR")))
                        }
                        
                        HStack{
                            Text("Gezahlter Betrag:")
                            Spacer()
                            Text(p.gezahlterBetrag(v: verwaltung).formatted(.currency(code: "EUR")))
                        }
                        
                        HStack{
                            Text("Offener Betrag:")
                            Spacer()
                            Text(p.offenerBetrag(v: verwaltung).formatted(.currency(code: "EUR"))).underline()
                        }.bold()
                    }
                    


        //            Text(p.notes) //TODO: anzeigen

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
                    Spacer()
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
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Wünsche")
                    .font(.title2.bold())
                Spacer()
            }
            
            ForEach(Array(p.wuenschBestellungen.keys).sorted(by: {$0.displayName < $1.displayName}), id: \.self) { item in
                Text("\(item.displayName): \(p.wuenschBestellungen[item] ?? 0)")
            }
        }
        Divider()
        VStack(alignment: .leading, spacing: 5){
            HStack{
                Text("Bestellungen (zugesichert)")
                    .font(.title2.bold())
                Spacer()
            }
            ForEach(Array(p.bestellungen.keys).sorted(by: {$0.displayName < $1.displayName}), id: \.self) { item in
                Text("\(item.displayName): \(p.bestellungen[item] ?? 0)")
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
