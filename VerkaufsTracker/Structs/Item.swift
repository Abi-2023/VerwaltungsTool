//
//  Item.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

enum Item: Codable, CaseIterable{
	case ball_ticket, after_show_ticket, pulli, buch

	// in cents
	var preis: Int {
		return [
			Item.ball_ticket: 5000,
			Item.after_show_ticket: 1000,
			Item.pulli: 3000,
			Item.buch: 2000
		][self]!
	}

	var displayName: String {
		return [
			Item.ball_ticket: "Ball Ticket",
			Item.after_show_ticket: "After Show Ticker",
			Item.pulli: "Pulli",
			Item.buch: "Buch"
		][self]!
	}

	var verfuegbar: Int {
		return [
			Item.ball_ticket: 600,
			Item.after_show_ticket: 200,
			Item.pulli: Int.max,
			Item.buch: Int.max
		][self]!
	}
}
