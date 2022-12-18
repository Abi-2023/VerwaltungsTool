//
//  PersonenView.swift
//  
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

struct PersonenView: View {
	@State var verwaltung: Verwaltung
    var body: some View {
		Text("Suchen") // TODO: searchbar
		List(verwaltung.personen) { person in
			Text(person.vorname)
		}
    }
}
