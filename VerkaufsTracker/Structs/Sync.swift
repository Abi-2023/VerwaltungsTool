//
//  Sync.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import Foundation

protocol Sync {
	var id: UUID { get set }
	var isSynced: Bool { get set }
	var lastUpdate: Date { get set }
	var lastServerEdit: Date { get set }
}
