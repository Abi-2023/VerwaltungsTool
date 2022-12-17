//
//  FormularMail.swift
//  
//
//  Created by Benedict on 17.12.22.
//

import Foundation
import SwiftSMTP

extension EmailManager {


	func generateFormEmail(person: Person) -> Mail{

		let subject = "Abi-Umfrage"

		let formName = "\(person.vorname) \(person.nachname.first ?? "?"). ".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Name"
		let formUrl = "***REMOVED***/viewform?usp=pp_url&entry.382473335=\(person.formID)&entry.2014446974=\(formName)"

		let content = """
   Hallo \(person.vorname),
   für die weiteren Planungen benötigen wir deine Hilfe. Bitte nimm an der Umfrage teil, damit wir wissen wie viele Ball-Tickets, etc. du haben möchtest.

   Hierfür erhälst du in dieser Email einen Link zu einem Google Formular.
   Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.

   \(formUrl)

   Abgabefrist ist der XX.XX.2023. Falls du bis dahin deine Meinung ändern solltest, kannst du über den Link das Formular erneut ausfüllen.

   Bei Fragen kannst du dich an diese Email wenden: \(SECRETS.EMAIL_Address)

   Viele Grüße,
   das Orga-Team

   [Diese Email wurde automatisch generiert und versendet.]
   """



		return Mail(from: self.senderMail,
					to: [self.mailUserFromPerson(person: person)],
					subject: subject,
					text: content)
	}

}
