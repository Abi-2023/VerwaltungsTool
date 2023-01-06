//
//  PersonenView.swift
//
//
//  Created by Benedict on 18.12.22.
//

import SwiftUI

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

struct PersonenView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var state: AppState
	@State var selectedPerson: Person?

	@State var gruppenTyp: GruppenTypen = ._Alle
	@State var searchQuery: String = ""
	@Binding var selectMode: Bool
	@Binding var selectedPersonen: [Person]
	@State var selectedAllPersonen: Bool = false

	@State var showFilterShortcut = false
	@State var zeigeAusgewaelte = false

	var body: some View {
		let displayedPersonen = zeigeAusgewaelte ? selectedPersonen : verwaltung.personen
			.filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle})
			.filter({searchQuery == "" || $0.searchableText.contains(searchQuery.uppercased())})
		
		VStack(spacing: 10){
			Text("Personenübersicht").font(.largeTitle.weight(.heavy))
			HStack {
				Button(action: {
					selectMode = true
					showFilterShortcut.toggle()
				}) {
					Image(systemName: "line.3.horizontal.decrease.circle")
				}.sheet(isPresented: $showFilterShortcut) {
					FilterView(verwaltung: verwaltung, selectedPersonen: $selectedPersonen, gruppenTyp: $gruppenTyp, showFilterShortcut: $showFilterShortcut)
				}

				TextField("Gebe einen Namen ein", text: $searchQuery)
					.textFieldStyle(.roundedBorder)
				Button(action: {
					searchQuery = ""
					UIApplication.shared.endEditing()
				}) {
					Image(systemName: searchQuery.isEmpty ? "magnifyingglass" : "delete.left")
				}
			}
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
					if(!selectedPersonen.isEmpty){
						Button("Aktionen"){
							state = .aktionen
						}
						Spacer()
					}
				}
				if selectMode {
					Button(action: {
						zeigeAusgewaelte.toggle()
					}) {
						Text(zeigeAusgewaelte ? "Alle anzeigen" : "Ausgewählte zeigen")
					}
					Spacer()
				}

				Button(action: {
					selectMode.toggle()
					selectedPersonen = []
				}) {
					if selectMode{
						Image(systemName: "xmark")
					} else {
						Text("Auswählen")
					}
				}
			}.font(.callout)
			Divider()
		}.padding([.leading, .trailing, .top])

		List {
			ForEach(displayedPersonen, id: \.self) { person in
				HStack{
					if selectMode {
						Button(action: {
							selectedPersonen.toggle(e: person)
						}) {
							HStack{
								Image(systemName: selectedPersonen.contains(person) ? "checkmark.circle.fill" : "circle")
								PersonRowItem(verwaltung: verwaltung, person: person)
							}
						}.buttonStyle(.borderless)
					} else {
						Button(action: {
							selectedPerson = person
						}) {
							PersonRowItem(verwaltung: verwaltung, person: person)
						}
						.buttonStyle(.borderless)
					}
				}
			}
			.sheet(item: $selectedPerson) { _ in
				PersonDetailView(verwaltung: verwaltung, person: $selectedPerson, selectedPersonen: $selectedPersonen, state: $state)
					.interactiveDismissDisabled(true)
			}

			if(displayedPersonen.isEmpty) {
				Text("Keine Person gefunden")
			}
		}.listStyle(.inset)
	}
}

struct PersonRowItem: View{
	let verwaltung: Verwaltung
	let person: Person
	var body: some View{
		HStack {
			Text(person.name)
				.foregroundColor(person.zuzahlenderBetrag == 0 ? .primary : person.offenerBetrag(v: verwaltung) <= 0 ? .green : .red)
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
}


struct FilterView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var selectedPersonen: [Person] {
		didSet {
			showFilterShortcut = false
		}
	}
	@Binding var gruppenTyp: GruppenTypen
	@Binding var showFilterShortcut: Bool

	var body: some View {

		VStack(spacing: 20){
			let alleInGruppe = verwaltung.personen.filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle})

			HStack{
				Text("Filter")
					.font(.largeTitle.bold())
				Spacer()
				Button(action: {
					showFilterShortcut = false
				}, label: {
					Image(systemName: "xmark")
				})
			}

			Picker("", selection: $gruppenTyp) {
				FilterButton("Alle").tag(GruppenTypen._Alle)
				FilterButton("Q2").tag(GruppenTypen._Q2er)
				FilterButton("Lehrer").tag(GruppenTypen._Lehrer)
			}.pickerStyle(.segmented)

			LazyVGrid(columns: Array(repeating: GridItem(), count: 2)){
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.hatFormEingetragen, default: ""] == "1"})
				}) {
					FilterButton("Form abgegeben")
				}
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.hatFormEingetragen, default: ""] != "1"})
				}) {
					FilterButton("Form noch nicht abgegeben")
				}

				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.offenerBetrag(v: verwaltung) <= 0})
				}) {
					FilterButton("Bezahlt")
				}
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.offenerBetrag(v: verwaltung) > 0})
				}) {
					FilterButton("Noch nicht bezahlt")
				}

				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.sendFormEmail, default: ""] == "1"})
				}) {
					FilterButton("Form-Mail bereits gesendet")
				}
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.sendFormEmail, default: ""] != "1"})
				}) {
					FilterButton("Form-Mail noch nicht gesendet")
				}

				Button(action: {
					selectedPersonen = alleInGruppe.filter({!$0.tickets.isEmpty && $0.tickets.allSatisfy({$0.versendet})})
				}) {
					FilterButton("Generierte Tickets gesendet")
				}
				Button(action: {
					selectedPersonen = alleInGruppe.filter({!$0.tickets.isEmpty && !$0.tickets.allSatisfy({$0.versendet})})
				}) {
					FilterButton("Nicht alle generierte Tickets gesendet")
				}
			}
			Spacer()
		}
		.padding()

	}
}

struct FilterButton: View{
	init(_ title: String){
		self.title = title
	}
	let title: String

	var body: some View{
		ZStack{
			RoundedRectangle(cornerRadius: 10)
				.foregroundColor(.blue)
				.frame(height: 70)
			Text(title)
				.font(.callout)
				.foregroundColor(.white)
		}
	}
}
