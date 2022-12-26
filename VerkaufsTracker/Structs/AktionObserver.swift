//
//  AktionObserver.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import Foundation

class AktionObserver: ObservableObject {

	@Published var prompt = ""
	@Published var log = ""

	func log(_ message: String) {
		DispatchQueue.main.sync {
			log += "\n"
			log += message
		}
	}

	func setPrompt(_ message: String) {
		DispatchQueue.main.sync {
			prompt = message
		}
	}

}

class Aktion {
	
}
