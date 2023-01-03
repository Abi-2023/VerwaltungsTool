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

		let subject = "Abi-Umfrage"

		let formName = formName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Name"
		let formUrl = "***REMOVED***/viewform?usp=pp_url&entry.382473335=\(formID)&entry.2014446974=\(formName)"

		let textContent = """
   Hallo \(vorname),
   Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher.

   Damit wir deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir deine Hilfe.

   Hierfür erhälst du in dieser E-Mail einen Link zu einem Google-Formular, bei dem du diese angeben kannst.
   Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.

   \(formUrl)

   Abgabefrist ist der XX.XX.2023. Falls du bis dahin deine Meinung ändern solltest, kannst du über den Link das Formular erneut ausfüllen.

   Bei Fragen kannst du dich an diese Email wenden: \(SECRETS.EMAIL_Address)

   Viele Grüße,
   das Orga-Team

   [Diese Email wurde automatisch generiert und versendet.]
   """

		let htmlMail = """
 <!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1"><meta name="color-scheme" content="light dark"/><meta name="supported-color-schemes" content="light dark"/> <style type="text/css"> @media (prefers-color-scheme: dark){.darkmode{background-color: #111111;}.darkmode h1, .darkmode p, .darkmode span, .darkmode a{color: #ffffff;}}</style> <style type="text/css"> #outlook a{padding: 0;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style><!--[if mso]> <noscript> <xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript><![endif]--><!--[if lte mso 11]> <style type="text/css"> .mj-outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100% !important; max-width: 100%;}}</style> <style media="screen and (min-width:480px)"> .moz-text-html .mj-column-per-100{width: 100% !important; max-width: 100%;}</style> <style type="text/css"> @media only screen and (max-width:480px){table.mj-full-width-mobile{width: 100% !important;}td.mj-full-width-mobile{width: auto !important;}}</style></head><body style="word-spacing:normal;background-color:#000000;"> <div style="background-color:#000000;"> <div style="margin:0px auto;max-width:600px;"> <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"> <tbody> <tr> <td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"> <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"> <tbody> <tr> <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;"> <tbody> <tr> <td style="width:300px;"> <img height="auto" src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEBLAEsAAD/4QCgRXhpZgAATU0AKgAAAAgABQEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAAEyAAIAAAAUAAAAWodpAAQAAAABAAAAbgAAAAAAAAEsAAAAAQAAASwAAAABMjAyMzowMTowMSAyMToxMjo1MQAAA6ABAAMAAAABAAEAAKACAAMAAAABASwAAKADAAMAAAABAEsAAAAAAAD/4QvOaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJYTVAgQ29yZSA1LjUuMCI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiBwaG90b3Nob3A6SUNDUHJvZmlsZT0ic1JHQiBJRUM2MTk2Ni0yLjEiIHhtcDpNb2RpZnlEYXRlPSIyMDIzLTAxLTAxVDIxOjEyOjUxKzAxOjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIzLTAxLTAxVDIxOjEyOjUxKzAxOjAwIj4gPGRjOnRpdGxlPiA8cmRmOkFsdD4gPHJkZjpsaSB4bWw6bGFuZz0ieC1kZWZhdWx0Ij5VbWZyYWdlTG9nbzwvcmRmOmxpPiA8L3JkZjpBbHQ+IDwvZGM6dGl0bGU+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249InByb2R1Y2VkIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZmZpbml0eSBEZXNpZ25lciAxLjEwLjYiIHN0RXZ0OndoZW49IjIwMjMtMDEtMDFUMjE6MTI6NTErMDE6MDAiLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDw/eHBhY2tldCBlbmQ9InciPz7/7QBYUGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAB8cAVoAAxslRxwCAAACAAQcAgUAC1VtZnJhZ2VMb2dvADhCSU0EJQAAAAAAEPGoMwH8NSIAvE8Ow3NVXo7/4gJkSUNDX1BST0ZJTEUAAQEAAAJUbGNtcwQwAABtbnRyUkdCIFhZWiAH5wABAAEAFAALAChhY3NwQVBQTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9tYAAQAAAADTLWxjbXMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtkZXNjAAABCAAAAD5jcHJ0AAABSAAAAEx3dHB0AAABlAAAABRjaGFkAAABqAAAACxyWFlaAAAB1AAAABRiWFlaAAAB6AAAABRnWFlaAAAB/AAAABRyVFJDAAACEAAAACBnVFJDAAACEAAAACBiVFJDAAACEAAAACBjaHJtAAACMAAAACRtbHVjAAAAAAAAAAEAAAAMZW5VUwAA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" style="border:0;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" width="300"/> </td></tr></tbody> </table> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FEE738;">Hallo \(vorname),</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher. <br></br> Damit wir deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir deine Hilfe. <br></br> Hierfür erhälst du in dieser E-Mail einen Link zu einem Google-Formular, bei dem du diese angeben kannst. Tippe dafür einfach auf den Button "Wünsche angeben":</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:14px;line-height:1;text-align:left;color:grey;">Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.</div></td></tr><tr> <td align="center" vertical-align="middle" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:separate;line-height:100%;"> <tr> <td align="center" bgcolor="#FEE738" role="presentation" style="border:none;border-radius:3px;cursor:auto;mso-padding-alt:10px 25px;background:#FEE738;" valign="middle"> <a href="\(formUrl)" style="display:inline-block;background:#FEE738;color:black;font-family:Helvetica;font-size:16px;font-weight:normal;line-height:120%;margin:0;text-decoration:none;text-transform:none;padding:10px 25px;mso-padding-alt:0px;border-radius:3px;" target="_blank"> <b>Wünsche angeben</b> </a> </td></tr></table> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Abgabefrist ist der XX.XX.2023. Falls du bis dahin deine Meinung ändern solltest und eine Änderung vornehmen möchtest, kannst du über den Link das Formular erneut ausfüllen. <br></br> Bei Fragen kannst du dich an diese E-Mail wenden: \(SECRETS.EMAIL_Address) <br></br> <br></br> Viele Grüße, <br>Das Orga-Team </div></td></tr><tr> <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;"> </p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisch generiert und versendet.</div></td></tr></tbody> </table> </div></td></tr></tbody> </table> </div></div></body></html>
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
