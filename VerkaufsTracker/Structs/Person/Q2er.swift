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
 <!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head><title></title><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><style type="text/css">#outlook a{padding:0;}body{margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;}table, td{border-collapse:collapse;mso-table-lspace:0pt;mso-table-rspace:0pt;}img{border:0;height:auto;line-height:100%; outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;}p{display:block;margin:13px 0;}</style><!--[if mso]> <noscript> <xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript><![endif]--><!--[if lte mso 11]> <style type="text/css"> .mj-outlook-group-fix{width:100% !important;}</style><![endif]--><style type="text/css">@media only screen and (min-width:480px){.mj-column-per-100{width:100% !important; max-width: 100%;}}</style><style media="screen and (min-width:480px)">.moz-text-html .mj-column-per-100{width:100% !important; max-width: 100%;}</style><style type="text/css">@media only screen and (max-width:480px){table.mj-full-width-mobile{width: 100% !important;}td.mj-full-width-mobile{width: auto !important;}}</style></head><body style="word-spacing:normal;background-color:#000000;"><div style="background-color:#000000;"><div style="margin:0px auto;max-width:600px;"><table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"><tbody><tr><td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"><div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"><table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"><tbody><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;"><tbody><tr><td style="width:300px;"><img height="auto" src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEBLAEsAAD/4QCgRXhpZgAATU0AKgAAAAgABQEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAAEyAAIAAAAUAAAAWodpAAQAAAABAAAAbgAAAAAAAAEsAAAAAQAAASwAAAABMjAyMzowMTowMiAxNDozMDo1MAAAA6ABAAMAAAABAAEAAKACAAMAAAABAZAAAKADAAMAAAABAGQAAAAAAAD/4QvOaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/PiA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJYTVAgQ29yZSA1LjUuMCI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiBwaG90b3Nob3A6SUNDUHJvZmlsZT0ic1JHQiBJRUM2MTk2Ni0yLjEiIHhtcDpNb2RpZnlEYXRlPSIyMDIzLTAxLTAyVDE0OjMwOjUwKzAxOjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIzLTAxLTAyVDE0OjMwOjUwKzAxOjAwIj4gPGRjOnRpdGxlPiA8cmRmOkFsdD4gPHJkZjpsaSB4bWw6bGFuZz0ieC1kZWZhdWx0Ij5VbWZyYWdlTG9nbzwvcmRmOmxpPiA8L3JkZjpBbHQ+IDwvZGM6dGl0bGU+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249InByb2R1Y2VkIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZmZpbml0eSBEZXNpZ25lciAxLjEwLjYiIHN0RXZ0OndoZW49IjIwMjMtMDEtMDJUMTQ6MzA6NTArMDE6MDAiLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDw/eHBhY2tldCBlbmQ9InciPz7/7QBYUGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAB8cAVoAAxslRxwCAAACAAQcAgUAC1VtZnJhZ2VMb2dvADhCSU0EJQAAAAAAEPGoMwH8NSIAvE8Ow3NVXo7/4gJkSUNDX1BST0ZJTEUAAQEAAAJUbGNtcwQwAABtbnRyUkdCIFhZWiAH5wABAAIADQAaAClhY3NwQVBQTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA9tYAAQAAAADTLWxjbXMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtkZXNjAAABCAAAAD5jcHJ0AAABSAAAAEx3dHB0AAABlAAAABRjaGFkAAABqAAAACxyWFlaAAAB1AAAABRiWFlaAAAB6AAAABRnWFlaAAAB/AAAABRyVFJDAAACEAAAACBnVFJDAAACEAAAACBiVFJDAAACEAAAACBjaHJtAAACMAAAACRtbHVjAAAAAAAAAAEAAAAMZW5VUwAA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" style="border:0;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" width="300"></td></tr></tbody></table></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FEE738;">Hallo \(vorname),</div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher.<br><br>Damit wir deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir deine Hilfe.<br><br>Hierfür erhälst du in dieser E-Mail einen Link zu einem Google-Formular, bei dem du diese angeben kannst. Tippe dafür einfach auf den Button "Wünsche angeben":</div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:Helvetica;font-size:14px;line-height:1;text-align:left;color:grey;">Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.</div></td></tr><tr><td align="center" vertical-align="middle" style="font-size:0px;padding:10px 25px;word-break:break-word;"><table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:separate;line-height:100%;"><tr><td align="center" bgcolor="#FEE738" role="presentation" style="border:none;border-radius:3px;cursor:auto;mso-padding-alt:10px 25px;background:#FEE738;" valign="middle"><a href="\(formUrl)" style="display:inline-block;background:#FEE738;color:black;font-family:Helvetica;font-size:16px;font-weight:normal;line-height:120%;margin:0;text-decoration:none;text-transform:none;padding:10px 25px;mso-padding-alt:0px;border-radius:3px;" target="_blank"><b>Wünsche angeben</b></a></td></tr></table></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Abgabefrist ist der XX.XX.2023. Falls du bis dahin deine Meinung ändern solltest und eine Änderung vornehmen möchtest, kannst du über den Link das Formular erneut ausfüllen.<br><br>Bei Fragen kannst du dich an diese E-Mail wenden: \(SECRETS.EMAIL_Address)<br><br><br><br>Viele Grüße,<br>Das Orga-Team</div></td></tr><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;"></p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisch generiert und versendet.</div></td></tr></tbody></table></div></td></tr></tbody></table></div></div></body></html>
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
