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

	var body: some View {
		HStack {
			TextField("filtern", text: $searchQuery)
				.padding()
			Button(action: {
				searchQuery = ""
			}) {
				Image(systemName: "xmark")
			}
		}
		HStack {
			Picker("a", selection: $gruppenTyp) {
				Text("Alle").tag(GruppenTypen._Alle)
				Text("Q2").tag(GruppenTypen._Q2er)
				Text("Lehrer").tag(GruppenTypen._Lehrer)
			}

		}
		List {
			ForEach(verwaltung.personen
				.filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle})
				.filter({searchQuery == "" || $0.searchableText.contains(searchQuery.uppercased())}),
					id: \.self) { person in
				Button(action: {
					selectedPerson = person
				}) {
					Text(person.name)
				}
			}
			.sheet(item: $selectedPerson) { _ in
				PersonDetailView(person: $selectedPerson)
					.interactiveDismissDisabled(true)
			}
		}
	}
}
