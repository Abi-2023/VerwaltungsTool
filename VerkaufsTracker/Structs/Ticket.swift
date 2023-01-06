//
//  Ticket.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import Foundation
import SwiftUI
import SwiftSMTP

class Ticket: Codable {
	let id: String
	var versendet: Bool
	let itemType: Item // ob das Ticket für die after show ist
	let owner: UUID
	let nth: Int
	
	init(owner: Person, type: Item, nth: Int) {
		id = UUID().uuidString
		versendet = false
		self.itemType = type
		self.owner = owner.id
		self.nth = nth
	}
	
}
