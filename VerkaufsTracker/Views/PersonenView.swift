//
//  PersonenView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonenView: View {
	@State var verwaltung: Verwaltung
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

	var body: some View {
		Text("Suchen") // TODO: searchbar
		HStack {
			Picker("a", selection: $gruppenTyp) {
				Text("Alle").tag(GruppenTypen._Alle)
				Text("Q2").tag(GruppenTypen._Q2er)
				Text("Lehrer").tag(GruppenTypen._Lehrer)
			}

		}
		List {
			ForEach(verwaltung.personen.filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle}), id: \.self) { person in
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
