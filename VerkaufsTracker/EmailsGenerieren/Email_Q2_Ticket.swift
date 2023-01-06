//
//  Email_Q2_Ticket.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation
import SwiftSMTP


extension Q2er {
	internal func generateTicketEmailInternal(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		var attachments: [Attachment] = []

		for ticket in tickets {
			attachments.append(ticket.generateAttatchment(verwaltung: v))
		}

		guard let mailUser = mailUser else {
			return nil
		}

		let mail = Mail(
			from: EmailManager.senderMail,
			to: [mailUser],
			subject: "Tickets",
			text: "Hier deine Tickets",
			attachments: attachments
		)

		return mail
	}
}
