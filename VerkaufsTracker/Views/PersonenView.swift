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
                }) {
                    Text("Alle auswählen")
                }
                Spacer()
                if(!selectedPersonen.isEmpty){
                    Button("Aktionen"){
                        state = .aktionen
                    }
                }
                Spacer()
            }           
            Button(action: {
                selectMode.toggle()
                selectedPersonen = []
            }) {
                Text(selectMode ? "Auswahl löschen" : "Auswählen")
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
						Text(person.name)
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
