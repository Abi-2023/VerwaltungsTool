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
	override var formName: String {"\(vorname) \(nachname.first ?? "?"). "}

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
		try super.init(from: decoder)
	}

	override func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try super.encode(to: encoder)
		try container.encode(vorname, forKey: .vorname)
		try container.encode(nachname, forKey: .nachname)
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

		let subject = "Abi Wunschabgabe"

		let formName = formName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Name"
		let formUrl = "***REMOVED***/viewform?usp=pp_url&entry.382473335=\(formID)&entry.2014446974=\(formName)"

		let textContent = """
   Hallo \(vorname),
   Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher.

   Damit wir deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir deine Hilfe.

   Hierfür erhälst du in dieser E-Mail einen Link zu einem Google-Formular, bei dem du diese angeben kannst.
   Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.

   \(formUrl)

   Abgabefrist ist der 15.02.2023. Falls du bis dahin deine Meinung ändern solltest, kannst du über den Link das Formular erneut ausfüllen.

   Bei Fragen kannst du dich an diese Email wenden: \(SECRETS.EMAIL_Address)

   Viele Grüße,
   das Orga-Team

   [Diese Email wurde automatisch generiert und versendet.]
   """

		let htmlMail = """
 <!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1"><meta name="color-scheme" content="light dark"/><meta name="supported-color-schemes" content="light dark"/> <style type="text/css"> @media (prefers-color-scheme: dark){.darkmode{background-color: #111111;}.darkmode h1, .darkmode p, .darkmode span, .darkmode a{color: #ffffff;}}</style> <style type="text/css"> #outlook a{padding: 0;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style><!--[if mso]> <noscript> <xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript><![endif]--><!--[if lte mso 11]> <style type="text/css"> .mj-outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100% !important; max-width: 100%;}}</style> <style media="screen and (min-width:480px)"> .moz-text-html .mj-column-per-100{width: 100% !important; max-width: 100%;}</style> <style type="text/css"> @media only screen and (max-width:480px){table.mj-full-width-mobile{width: 100% !important;}td.mj-full-width-mobile{width: auto !important;}}</style></head><body style="word-spacing:normal;background-color:#000000;"> <div style="background-color:#000000;"> <div style="margin:0px auto;max-width:600px;"> <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"> <tbody> <tr> <td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"> <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"> <tbody> <tr> <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;"> <tbody> <tr> <td style="width:300px;"> <img height="auto" src="data:image/jpeg;base64,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" style="border:0;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" width="300"/> </td></tr></tbody> </table> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FEE738;">Hallo \(vorname),</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher. <br></br> Damit wir deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir deine Hilfe. <br></br> Hierfür erhälst du in dieser E-Mail einen Link zu einem Google-Formular, bei dem du diese angeben kannst. Tippe dafür einfach auf den Button "Wünsche angeben":</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:14px;line-height:1;text-align:left;color:grey;">Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.</div></td></tr><tr> <td align="center" vertical-align="middle" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:separate;line-height:100%;"> <tr> <td align="center" bgcolor="#FEE738" role="presentation" style="border:none;border-radius:3px;cursor:auto;mso-padding-alt:10px 25px;background:#FEE738;" valign="middle"> <a href="\(formUrl)" style="display:inline-block;background:#FEE738;color:black;font-family:Helvetica;font-size:16px;font-weight:normal;line-height:120%;margin:0;text-decoration:none;text-transform:none;padding:10px 25px;mso-padding-alt:0px;border-radius:3px;" target="_blank"> <b>Wünsche angeben</b> </a> </td></tr></table> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Abgabefrist ist der 15.02.2023. Falls du bis dahin deine Meinung ändern solltest und eine Änderung vornehmen möchtest, kannst du über den Link das Formular erneut ausfüllen. <br></br> Bei Fragen kannst du dich an diese E-Mail wenden: \(SECRETS.EMAIL_Address) <br></br> <br></br> Viele Grüße, <br>Das Orga-Team </div></td></tr><tr> <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;"> </p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisch generiert und versendet.</div></td></tr></tbody> </table> </div></td></tr></tbody> </table> </div></div></body></html>
"""

		let htmlAttachment = Attachment(htmlContent: htmlMail)

		return Mail(from: EmailManager.senderMail,
					to: [mailUser!], //TODO: maybe handle optional
					subject: subject,
					text: textContent,
					attachments: [htmlAttachment]
		)
	}

}
