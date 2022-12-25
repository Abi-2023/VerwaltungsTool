//
//  Ticket.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import Foundation

class Ticket {
	let id: String
	let versendet: Bool
	unowned let owner: Person

	init(owner: Person) {
		id = UUID().uuidString
		versendet = false
		self.owner = owner
	}
}
