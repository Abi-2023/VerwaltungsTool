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
	@Published var aktiv = false
	@Published var finished = false

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

	func activate() {
		DispatchQueue.main.sync {
			aktiv = true
		}
	}

	func deactivate() {
		DispatchQueue.main.sync {
			aktiv = false
		}
	}

	func finish() {
		DispatchQueue.main.sync {
			finished = true
		}
	}

	func clear() {
		prompt = ""
		log = ""
		aktiv = false
		finished = false
	}

}

class Aktion {
	
}
