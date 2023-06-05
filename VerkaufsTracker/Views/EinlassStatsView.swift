//
//  EinlassStatsView.swift
//  
//
//  Created by Benedict on 30.05.23.
//

import SwiftUI


struct EinlassStatsView: View {
	@ObservedObject var verwaltung: Verwaltung
	@ObservedObject var scanConnector: ScanConnector

	var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	var dateFormatter: DateFormatter {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "hh:mm:ss"
			dateFormatter.locale = Locale(identifier: "de_DE")
			return dateFormatter
		}

	init(verwaltung: Verwaltung) {
		self.verwaltung = verwaltung
		self.scanConnector = ScanConnector()
	}

	@State var mode: Int = 0

	var body: some View {
		VStack {
			Text("Scans: \(scanConnector.records.count)")
			Text("Aktiv: \(Set(scanConnector.records.filter({$0.active}).map({$0.ticketId})).count)")
			Stepper("Mode", value: $mode, in: 0...1, step: 1)
			switch mode {
			case 0: // Letzte Scans
				ScrollView {
					LazyVStack {
						ForEach(scanConnector.records, id: \.self) { record in
							VStack {
								HStack {
									Text(dateFormatter.string(from: record.timestamp))
									Text(verwaltung.personen.first(where: {$0.tickets.contains(where: {$0.id == record.ticketId})})?.name ?? "Unbekannt")
								}
								Divider()
							}
						}
					}
				}
			case 1: //Tisch Übersicht
				ScrollView {
					ForEach(tische, id: \.self) { tisch in
						Text("\(tisch.name): \(scanConnector.aktivVonGruppe(personen: verwaltung.personenAnTisch(name: tisch.name)))/\(verwaltung.zahlAnTisch(name: tisch.name))/\(tisch.kapazitaet)")
							.font(.title2.bold())
							.padding(.top, 10)
						ForEach(verwaltung.personenAnTisch(name: tisch.name)) { p in
							let aktivVonPerson = scanConnector.aktivVonPerson(person: p)
							let ticketsPerson = p.bestellungen[.ball_ticket] ?? -1
							Text("\(p.name): \(aktivVonPerson)/\(ticketsPerson)")
								.foregroundColor(ticketsPerson == aktivVonPerson ? .green : .primary)
						}
						Divider()
					}
				}
			default:
				Text("err")
			}
		}
		.onReceive(timer, perform: { _ in
			scanConnector.neueRecordsAbfragen()
		})
	}
}
