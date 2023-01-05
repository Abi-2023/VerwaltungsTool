//
//  Aktion_sendeBezahlEmail.swift
//  
//
//  Created by Benedict on 05.01.23.
//

import Foundation
import SwiftSMTP

extension Aktion {

	//resend: wenn Email bereits gesendet wurde wird bei false nicht nochmal gesendet
	static func sendBezahlEmails(personen: [Person], observer: AktionObserver, resend: Bool = false) {
		observer.activate(name: "sende Bezahl Emails")
		observer.log("start generating emails...")
		observer.setPrompt("GeneratingEmails")
		var emailQueue: [(person: Person, mail: Mail)] = []

		for person in personen {
			if person.extraFields[.sendBezahlEmail, default: "0"] == "1" && !resend {
				observer.log("skipping \(person.name) (already send)")
				continue
			}
			if person.zuzahlenderBetrag <= 0 {
				observer.log("skipping \(person.name) (keine Bestellung)")
				continue
			}
			let mail = type(of: person) == Q2er.self ? (person as! Q2er).generateBezahlEmail(ao: observer) : person.generateBezahlEmail()
			if let mail = mail {
				emailQueue.append((person, mail))
			} else {
				observer.log("could not generate Email for: \(person.name)")
			}
		}

		observer.log("generated \(emailQueue.count) EMails")
		observer.log("start sending")

		let mailManager = EmailManager()
		var i = 0
		let workerGroup = DispatchGroup()
		for mail in emailQueue {
			observer.setPrompt("sending \(0) / \(emailQueue.count)")
			workerGroup.enter()
			mailManager.sendMail(mail: mail.mail) { error in
				if let error {
					print(error)
					observer.log("error sending email to: \(mail.person.name) [\(error)]")
					mail.person.notes += "\nFehler bei Bezahl-Email \(Date.now.formatted(.dateTime))"
				} else {
					observer.log("send email to: \(mail.person.name)")
					mail.person.extraFields[.sendBezahlEmail] = "1"
					mail.person.notes += "\nBezahl-Email gesendet \(Date.now.formatted(.dateTime))"
				}
				workerGroup.leave()
			}
			i += 1
			workerGroup.wait()
		}
		observer.setPrompt("finished")
		observer.log("finished sending")
		observer.finish()
	}
}
