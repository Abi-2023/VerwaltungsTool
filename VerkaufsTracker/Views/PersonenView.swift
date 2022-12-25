//
//  PersonenView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonenView: View {
	@ObservedObject var verwaltung: Verwaltung
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
	@State var selectMode = false {
		didSet {
			selectedPersonen = []
		}
	}
	@State var selectedPersonen: [Person] = []

	var body: some View {
		HStack {
			Picker("a", selection: $gruppenTyp) {
				Text("Alle").tag(GruppenTypen._Alle)
				Text("Q2").tag(GruppenTypen._Q2er)
				Text("Lehrer").tag(GruppenTypen._Lehrer)
			}
			TextField("filtern", text: $searchQuery)
				.textFieldStyle(.roundedBorder)
			Button(action: {
				searchQuery = ""
			}) {
				Image(systemName: "xmark")
			}
		}.padding()

		Button(action: {
			selectMode.toggle()
		}) {
			Text(selectMode ? "clear selection" : "auswählen")
		}

		let displayedPersonen = verwaltung.personen
			.filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle})
			.filter({searchQuery == "" || $0.searchableText.contains(searchQuery.uppercased())})

		if(selectMode) {
			Button(action: {
				displayedPersonen.forEach({ person in
					selectedPersonen.toggle(e: person)
				})
			}) {
				Text("Alle")
			}
		}

		List {
			ForEach(displayedPersonen, id: \.self) { person in
				HStack{
					if selectMode {
						Button(action: {
							selectedPersonen.toggle(e: person)
						}) {
							Image(systemName: selectedPersonen.contains(person) ? "x.circle" : "circle")
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
				PersonDetailView(person: $selectedPerson)
					.interactiveDismissDisabled(true)
			}

			if(displayedPersonen.isEmpty) {
				Text("keine Person gefunden")
			}
		}
	}
}
