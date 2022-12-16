//
//  EmailManager.swift
//  
//
//  Created by Benedict on 16.12.22.
//

import Foundation
import SwiftSMTP

class EmailManager {

	let smtp = SMTP(
		hostname: SECRETS.EMAIL_Host,     // SMTP server address
		email: SECRETS.EMAIL_Username,        // username to login
		password: SECRETS.EMAIL_Password
	)

	let senderMail = Mail.User(name: SECRETS.EMAIL_Name, email: SECRETS.EMAIL_Address)

	init() {

	}

	func sendEmail(recipientAdress: String,
				   recipientName: String?,
				   subject: String,
				   text: String
	) {
		let recipientMail = Mail.User(name: recipientName, email: recipientAdress)

		let mail = Mail(
			from: senderMail,
			to: [recipientMail],
			subject: subject,
			text: text
		)

		smtp.send(mail) { (error) in
			if let error = error {
				print(error)
			} else {
				print("Email erfolgreich versendet")
			}
		}
	}

}
