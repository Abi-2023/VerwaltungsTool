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
	var body: some View {
		Text("Suchen") // TODO: searchbar
		List {
			ForEach(verwaltung.personen, id: \.self) { person in
				Text(person.notes)
					.onTapGesture {
//						selectedPerson = person
					}
			}
			.sheet(item: $selectedPerson) { _ in
				PersonDetailView(person: $selectedPerson)
					.interactiveDismissDisabled(true)
			}
		}
	}
}
