//
//  Item.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

let pulliGRPosition = "Pulli §" //§ = Größe z.B. XL

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
			Item.ball_ticket: "Ball-Ticket",
			Item.after_show_ticket: "After-Show-Party-Ticket",
			Item.pulli: "Pulli",
			Item.buch: "Buch"
		][self]!
	}

	var rechnungsPosition: String {
		return [
			Item.ball_ticket: "Ball Ticket (\(preis/100)€)",
			Item.after_show_ticket: "After-Show-Party-Ticket (\(preis/100)€)",
			Item.pulli: "Pulli (\(preis/100)€)",
			Item.buch: "Buch (\(preis/100)€)"
		][self]!
	}

	var verfuegbar: Int {
		return [
			Item.ball_ticket: 600,
			Item.after_show_ticket: 350,
			Item.pulli: Int.max,
			Item.buch: Int.max
		][self]!
	}
}
