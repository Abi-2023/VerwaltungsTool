//
//  Aktion_sendeAngekommen.swift
//  
//
//  Created by Benedict on 24.01.23.
//

import Foundation

import SwiftSMTP


extension Aktion {

	static public func sendeAngekommen(personen: [Person], verwaltung v: Verwaltung, ao: AktionObserver, resend: Bool) {
		ao.activate(name: "sende Ticket")

		// MARK: - generiere Emails
		ao.log("start generating emails...")
		ao.setPrompt("Generiere Emails")
		var emailQueue: [(person: Person, mail: Mail)] = []

		for person in personen {
			if person.zuzahlenderBetrag <= 0 {
				ao.log("Skipping \(person.name) keine Bestellung")
				continue
			}

			if person.offenerBetrag(v: v) > 0 {
				ao.log("Skipping \(person.name) noch nicht bezahlt")
				continue
			}

			if person.extraFields[.sendAngekommenEmail, default: "0"] == "1" && !resend {
				ao.log("skipping \(person.name) (already send)")
				continue
			}

			if let mail = person.generateAngekommenEmail(v: v) {
				emailQueue.append((person, mail))
			} else {
				ao.log("\(person.name) konnte Email nicht generieren")
			}
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

					mail.person.extraFields[.sendAngekommenEmail] = "1"
					mail.person.notes += "\n Bestätigungs email gesendet \(Date().formatted(date: .abbreviated, time: .standard))"
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
