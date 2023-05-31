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

	var body: some View {
		VStack {
			Text("Scans: \(scanConnector.records.count)")
			Text("Aktiv: \(Set(scanConnector.records.filter({$0.active}).map({$0.ticketId})).count)")
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
		}
		.onReceive(timer, perform: { _ in
			scanConnector.neueRecordsAbfragen()
		})
	}
}
