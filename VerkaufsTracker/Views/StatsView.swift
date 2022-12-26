//
//  StatsView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct StatsView: View {
	let verwaltung: Verwaltung
	var body: some View {
		Text("Statistiken")
		let wunschTickets = verwaltung.personen.map({$0.wuenschBestellungen[.ball_ticket] ?? 0}).reduce(0, +)
		Text("gewünschte Tickets: \(wunschTickets) / \(Item.ball_ticket.verfuegbar) (\((Int(Float(wunschTickets) / Float(Item.ball_ticket.verfuegbar)*100)))%)")

		let formSubmitted = verwaltung.personen.filter({$0.extraFields["hatFormEingetragen", default: ""] == "1"}).count
		Text("Form ausgefüllt: \(formSubmitted) / \(verwaltung.personen.count) (\((Int(Float(formSubmitted) / Float(verwaltung.personen.count)*100)))%)")
	}
}
