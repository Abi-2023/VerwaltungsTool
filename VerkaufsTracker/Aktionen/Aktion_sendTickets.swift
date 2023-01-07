//
//  Aktion_sendTickets.swift
//  
//
//  Created by Benedict on 28.12.22.
//

import Foundation
import SwiftSMTP


extension Aktion {

	// nurVoll: sendet nur, wenn die anzahl der Tickets gleich der Anzahl der bestellten Tickets ist+
	// wenn nicht: muss vorher tickets generieren und auffüllen
	// TODO: maybe vor dem run hier auffüllen
	// aber unsicher, ob man das getrennt braucht
	static public func sendeTickets(personen: [Person], verwaltung v: Verwaltung, ao: AktionObserver, resend: Bool, nurVoll: Bool) {
		ao.activate(name: "sende Ticket")

		// MARK: - generiere Emails
		ao.log("start generating emails...")
		ao.setPrompt("Generiere Emails")
		var emailQueue: [(person: Person, mail: Mail)] = []

		for person in personen {
			if person.tickets.isEmpty{
				ao.log("skipping: \(person.name) (keine Tickets)")
				continue
			}

			if person.tickets.allSatisfy({$0.versendet}) && !resend{
				ao.log("skipping: \(person.name) (alle schon gesendet)")
				continue
			}

			var vollGeneriert = true
			for itemType in [Item.ball_ticket, .after_show_ticket] {
				let anzahlTickets = person.tickets.filter({$0.itemType == itemType}).count
				if anzahlTickets < person.bestellungen[itemType, default: 0] {
					vollGeneriert = false
				} else if anzahlTickets > person.bestellungen[itemType, default: 0] {
					ao.log("ERR: \(person.name) hat zu viele Tickets vom Typ \(itemType)")
					continue
				}
			}

			if nurVoll && !vollGeneriert {
				ao.log("skipping: \(person.name) (nicht voll generiert)")
				continue
			}

			let workerGroup = DispatchGroup()
			workerGroup.enter()
			DispatchQueue.main.async {
				if let mail = person.generateTicketEmail(v: v, ao: ao) {
					emailQueue.append((person, mail))
				} else {
					ao.log("Could not generateEmail for \(person.name)")
				}
				workerGroup.leave()
			}
			workerGroup.wait()
		}


		// MARK: - sende Emails
		ao.log("generated \(emailQueue.count) EMails")
		ao.log("start sending")

		let mailManager = EmailManager()
		var i = 0
		let workerGroup = DispatchGroup()
		for mail in emailQueue {
			ao.setPrompt("sending \(0) / \(emailQueue.count)")
			workerGroup.enter()
			mailManager.sendMail(mail: mail.mail) { error in
				if let error {
					print(error)
					ao.log("error sending email to: \(mail.person.name) [\(error)]")
					mail.person.notes += "\nFehler bei Form-Email \(Date.now.formatted(.dateTime))"
				} else {
					ao.log("send email to: \(mail.person.name)")
					mail.person.tickets.forEach({$0.versendet = true})
					mail.person.notes += "\n Tickets-Email gesendet \(Date.now.formatted(.dateTime)) mit \(mail.person.tickets.count) tickets"
				}
				workerGroup.leave()
			}
			i += 1
			workerGroup.wait()
		}
		ao.setPrompt("finished")
		ao.log("finished sending")
		ao.finish()
	}

}
