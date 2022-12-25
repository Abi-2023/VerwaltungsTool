//
//  Q2er.swift
//  
//
//  Created by Benedict on 23.12.22.
//

import Foundation
import SwiftSMTP

class Q2er: Person {

	var vorname: String
	var nachname: String
	override var name: String { get {"\(vorname) \(nachname)"} set {}}

	init(vorname: String, nachname: String, email: String?, notes: String, bestellungen: [UUID : Int], extraFields: [String : String], verwaltung: Verwaltung) {
		self.vorname = vorname
		self.nachname = nachname
		super.init(name: "", email: email, verwaltung: verwaltung)
	}

	private enum CodingKeys: String , CodingKey {case vorname, nachname}
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		vorname = try container.decode(String.self, forKey: .vorname)
		nachname = try container.decode(String.self, forKey: .nachname)
		let superDecoder = try container.superDecoder()
		try super.init(from: superDecoder)
	}

	static func == (lhs: Q2er, rhs: Q2er) -> Bool {
		lhs.id == rhs.id &&
		lhs.email == rhs.email &&
		lhs.notes == rhs.notes &&
		lhs.bestellungen == rhs.bestellungen &&
		lhs.extraFields == rhs.extraFields &&
		lhs.formID == rhs.formID &&
		lhs.vorname == rhs.vorname &&
		lhs.nachname == rhs.nachname
	}


	override func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(email)
		hasher.combine(notes)
		hasher.combine(bestellungen)
		hasher.combine(extraFields)
		hasher.combine(formID)

		hasher.combine(vorname)
		hasher.combine(nachname)
	}

	override func generateFormEmail() -> Mail{

		let subject = "Abi-Umfrage"

		let formName = "\(vorname) \(nachname.first ?? "?"). ".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Name"
		let formUrl = "***REMOVED***/viewform?usp=pp_url&entry.382473335=\(formID)&entry.2014446974=\(formName)"

		let content = """
   Hallo \(vorname),
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



		return Mail(from: EmailManager.senderMail,
					to: [Mail.User(name: name, email: email!)],
					subject: subject,
					text: content)
	}

}
