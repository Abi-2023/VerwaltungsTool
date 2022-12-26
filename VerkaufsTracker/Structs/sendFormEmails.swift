//
//  sendFormEmails.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import Foundation
import SwiftSMTP

extension Aktion {

	static func sendFormEmails(personen: [Person], observer: AktionObserver) {
		observer.activate()
		observer.log("start generating emails...")
		observer.setPrompt("GeneratingEmails")
		var emailQueue: [(person: Person, mail: Mail)] = []

		for person in personen {
			let mail = person.generateFormEmail()
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
					mail.person.notes += "\nFehler bei Form-Email \(Date.now.formatted(.dateTime))"
				} else {
					observer.log("send email to: \(mail.person.name)")
					mail.person.extraFields["sendFormEmail"] = "1"
					mail.person.notes += "\nForm-Email gesendet \(Date.now.formatted(.dateTime))"
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
