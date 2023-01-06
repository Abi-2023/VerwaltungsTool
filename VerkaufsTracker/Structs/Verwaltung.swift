//
//  Verwaltung.swift
//  
//
//  Created by Benedict on 22.12.22.
//

import Foundation

class Verwaltung: ObservableObject {

	@Published var cloud: CloudState = .disconnected

	@Published var personen: [Person] = []
	@Published var transaktionen: [Transaktion] = []

	@Published var lastFetchForm: Date = Date(timeIntervalSince1970: 0) { didSet {print("set last \(lastFetchForm)")}}
	@Published var lastFetchTransaktionen: Date = Date(timeIntervalSince1970: 0)
	@Published var finalPrice = true
	@Published var verteilungDeaktiviert = false

	@Published var cloudStatus: CloudStatus? = nil
	var logs: Int = 0


	init() {
		print("neue Verwaltugn")
	}

	func generateFormId() -> String{
		//regex: /[ABCDEF][175963][SEFWQX][MNDQS5][W3YJ52]/
		let options = [
			["A", "B", "C", "D", "E", "F"],
			["1", "7", "5", "9", "6", "3"],
			["S", "E", "F", "W", "Q", "X"],
			["M", "N", "D", "Q", "S", "5"],
			["W", "3", "Y", "J", "5", "2"],
		]
		while true {
			let formId = options.map({$0.randomElement()!}).reduce("", +)
			if !personen.map({$0.formID}).contains(formId) {
				return formId
			}
		}
	}


	var offenePersonen: Int {
		personen.filter({$0.offenerBetrag(v: self) > 0}).count
	}

	var gezahltePersonen: Int {
		personenMitBestellung - offenePersonen
	}

	var personenMitBestellung: Int {
		personen.filter({$0.zuzahlenderBetrag != 0}).count
	}

	var offenerBetrag: Int {
		personen.map({max(0, $0.offenerBetrag(v: self))}).reduce(0, +)
	}

	var insgGezahlt: Int {
		transaktionen.map({$0.betrag}).reduce(0, +)
	}

	var zuVielGezahlt: Int {
		personen.map({$0.offenerBetrag(v: self) < 0 ? abs($0.offenerBetrag(v: self)) : 0}).reduce(0, +)
	}

}
