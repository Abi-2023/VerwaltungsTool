//
//  Extensions.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import Foundation

extension Array where Element: Hashable{

	mutating func toggle(e: (Element)) {
		if self.contains(e) {
			self.removeAll(where: {$0 == e})
		} else {
			self.append(e)
		}
	}
}
