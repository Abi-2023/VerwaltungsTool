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

	@State var showFilterShortcut = false
	@State var zeigeAusgewaelte = false

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

		let displayedPersonen = zeigeAusgewaelte ? selectedPersonen : verwaltung.personen
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

			if selectMode {
				Button(action: {
					zeigeAusgewaelte.toggle()
				}) {
					Text(zeigeAusgewaelte ? "alle" : "ausgewälte")
				}.sheet(isPresented: $showFilterShortcut) {
					FilterView(verwaltung: verwaltung, selectedPersonen: $selectedPersonen, gruppenTyp: gruppenTyp, showFilterShortcut: $showFilterShortcut)
				}
			}

			Button(action: {
				selectMode = true
				showFilterShortcut.toggle()
			}) {
				Text("Shortcuts")
			}.sheet(isPresented: $showFilterShortcut) {
				FilterView(verwaltung: verwaltung, selectedPersonen: $selectedPersonen, gruppenTyp: gruppenTyp, showFilterShortcut: $showFilterShortcut)
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


struct FilterView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var selectedPersonen: [Person] {
		didSet {
			showFilterShortcut = false
		}
	}
	@State var gruppenTyp: GruppenTypen
	@Binding var showFilterShortcut: Bool

	var body: some View {

		VStack(spacing: 20){
			let alleInGruppe = verwaltung.personen.filter({type(of: $0) == gruppenTyp.type || gruppenTyp == ._Alle})
			Text("Wähle...")
				.font(.largeTitle)
				.padding(30)

			HStack {
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.hatFormEingetragen, default: ""] == "1"})
				}) {
					Text("Form Abgegeben")
				}
				Spacer()
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.hatFormEingetragen, default: ""] != "1"})
				}) {
					Text("Form nicht Abgegeben")
				}
			}

			HStack {
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.offenerBetrag(v: verwaltung) <= 0})
				}) {
					Text("Bezahlt")
				}
				Spacer()
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.offenerBetrag(v: verwaltung) > 0})
				}) {
					Text("nicht bezahlt")
				}
			}

			HStack {
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.sendFormEmail, default: ""] == "1"})
				}) {
					Text("send Form Email")
				}
				Spacer()
				Button(action: {
					selectedPersonen = alleInGruppe.filter({$0.extraFields[.sendFormEmail, default: ""] != "1"})
				}) {
					Text("noch keine Form Email")
				}
			}

			HStack {
				Button(action: {
					selectedPersonen = alleInGruppe.filter({!$0.tickets.isEmpty && $0.tickets.allSatisfy({$0.versendet})})
				}) {
					Text("generierte Tickets gesendet")
				}
				Spacer()
				Button(action: {
					selectedPersonen = alleInGruppe.filter({!$0.tickets.isEmpty && !$0.tickets.allSatisfy({$0.versendet})})
				}) {
					Text("nicht alle generierte Tickets gesendet")
				}
			}

			Spacer()
		}
		.padding()

	}
}
