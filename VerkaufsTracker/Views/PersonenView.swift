//
//  PersonenView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonenView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var state: AppState
	@State var selectedPerson: Person?

	enum GruppenTypen: String {
		case _Alle
		case _Q2er
		case _Lehrer

		var type: Any.Type {
			switch self {
			case ._Alle:
				return Person.self
			case ._Q2er:
				return Q2er.self
			case ._Lehrer:
				return Lehrer.self
			}
		}
	}

	@State var gruppenTyp: GruppenTypen = ._Alle
	@State var searchQuery: String = ""
	@Binding var selectMode: Bool
	@Binding var selectedPersonen: [Person]
    @State var selectedAllPersonen: Bool = false

	var body: some View {
		HStack {
			Picker("a", selection: $gruppenTyp) {
				Text("Alle").tag(GruppenTypen._Alle)
				Text("Q2").tag(GruppenTypen._Q2er)
				Text("Lehrer").tag(GruppenTypen._Lehrer)
			}
			TextField("Filtern", text: $searchQuery)
				.textFieldStyle(.roundedBorder)
			Button(action: {
				searchQuery = ""
				UIApplication.shared.endEditing()
			}) {
				Image(systemName: "xmark")
			}
		}.padding()
        
        let displayedPersonen = verwaltung.personen
            .filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle})
            .filter({searchQuery == "" || $0.searchableText.contains(searchQuery.uppercased())})
        
        HStack{
            if(selectMode) {
                Button(action: {
                    displayedPersonen.forEach({ person in
                        selectedPersonen.toggle(e: person)
                    })
                    selectedAllPersonen.toggle()
                }) {
                    Text(selectedAllPersonen ? "Keine" : "Alle")
                }
                Spacer()
            }
            Button(action: {
                selectMode.toggle()
                selectedPersonen = []
            }) {
                Text(selectMode ? "Auswahlmodus aus" : "Auswahlmodus an")
            }
            if(selectMode){
                if(!selectedPersonen.isEmpty){
                    Spacer()
                    Button("Aktionen"){
                        state = .aktionen
                    }
                }
            }

        }.padding([.leading, .trailing])
		List {
			ForEach(displayedPersonen, id: \.self) { person in
				HStack{
					if selectMode {
						Button(action: {
							selectedPersonen.toggle(e: person)
						}) {
							Image(systemName: selectedPersonen.contains(person) ? "checkmark.circle.fill" : "circle")
						}
					}
					Button(action: {
						selectedPerson = person
					}) {
                        HStack {
                            Text(person.name)
                                .foregroundColor(person.zuzahlenderBetrag == 0 ? .gray : person.offenerBetrag(v: verwaltung) <= 0 ? .green : .red)
                            
                            Spacer()
                            
                            
                            if(person.extraFields[extraFields(rawValue: "sendFormEmail")!] != "0" && person.extraFields[extraFields(rawValue: "hatFormEingetragen")!] != "0" &&
                               person.offenerBetrag(v: verwaltung) <= 0 &&  person.zuzahlenderBetrag != 0){
                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                            } else {
                                if(person.extraFields[extraFields(rawValue: "sendFormEmail")!] != nil){
                                    Image(systemName: "paperplane")
                                }
                                
                                if(person.extraFields[extraFields(rawValue: "hatFormEingetragen")!] != nil){
                                    Image(systemName: "doc")
                                }
                            }
                        }
					}
					.buttonStyle(.borderless)

				}
			}
			.sheet(item: $selectedPerson) { _ in
				PersonDetailView(verwaltung: verwaltung, person: $selectedPerson, selectedPersonen: $selectedPersonen, state: $state)
					.interactiveDismissDisabled(true)
			}

			if(displayedPersonen.isEmpty) {
				Text("Keine Person gefunden")
			}
		}
	}
}
