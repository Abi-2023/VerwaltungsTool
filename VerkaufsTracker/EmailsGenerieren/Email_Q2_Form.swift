//
//  Email_Q2_Form.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation
import SwiftSMTP

extension Q2er {
	internal func generateFormEmailInternal(ao: AktionObserver? = nil) -> Mail? {
		guard let mailUser = mailUser else {
			ao?.log("err: \(name); no mail user")
			return nil
		}
		let subject = "Wunschabgabe für Deine Abi-Feierlichkeiten"

		let formName = formName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Name"
		let formUrl = "***REMOVED***/viewform?usp=pp_url&entry.382473335=\(formID)&entry.2014446974=\(formName)"

		let textContent = """
   Hallo \(vorname),
   Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher.

   Damit wir Deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir Deine Hilfe.

   Hierfür erhälst Du in dieser E-Mail einen Link zu einem Google-Formular, bei dem Du diese angeben kannst.
   Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.

   \(formUrl)

   Abgabefrist ist der 15.02.2023. Falls Du bis dahin Deine Meinung ändern solltest, kannst Du über den Link das Formular erneut ausfüllen.

   Bei Fragen kannst Du dich an diese Email wenden: \(SECRETS.EMAIL_Address)

   Viele Grüße,
   das Orga-Team

   [Diese Email wurde automatisch generiert und versendet.]
   """

		let htmlMail = """
 <!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1"><meta name="color-scheme" content="light dark"/><meta name="supported-color-schemes" content="light dark"/> <style type="text/css"> @media (prefers-color-scheme: dark){.darkmode{background-color: #111111;}.darkmode h1, .darkmode p, .darkmode span, .darkmode a{color: #ffffff;}}</style> <style type="text/css"> #outlook a{padding: 0;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style><!--[if mso]> <noscript> <xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript><![endif]--><!--[if lte mso 11]> <style type="text/css"> .mj-outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100% !important; max-width: 100%;}}</style> <style media="screen and (min-width:480px)"> .moz-text-html .mj-column-per-100{width: 100% !important; max-width: 100%;}</style> <style type="text/css"> @media only screen and (max-width:480px){table.mj-full-width-mobile{width: 100% !important;}td.mj-full-width-mobile{width: auto !important;}}</style></head><body style="word-spacing:normal;background-color:#000000;"> <div style="background-color:#000000;"> <div style="margin:0px auto;max-width:600px;"> <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"> <tbody> <tr> <td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"> <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"> <tbody><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;"><tbody><tr><td style="width:100px;"><img height="auto" src="\(EmailManager.headerImage)" style="border:0;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" width="100" /></td></tr></tbody></table></td></tr><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><p style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:100%;"></p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FFE81F;">Hallo \(vorname),</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Die Abi-Feierlichkeiten unserer Stufe rücken allmählich näher. <br></br> Damit wir Deine Wünsche für die Feierlichkeiten (Zeugnisvergabe, Abiball, Abibuch, etc.) berücksichtigen können, brauchen wir Deine Hilfe. <br></br> Du erhältst einen Link zu einem Google-Formular, wo Du Deine Wünsche angeben kannst. Tippe dafür einfach auf den Button "Wünsche angeben":</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:14px;line-height:1;text-align:left;color:grey;">Der Link ist für jede Person individuell. Teile ihn daher nicht mit anderen.</div></td></tr><tr> <td align="center" vertical-align="middle" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:separate;line-height:100%;"> <tr> <td align="center" bgcolor="#FEE738" role="presentation" style="border:none;border-radius:3px;cursor:auto;mso-padding-alt:10px 25px;background:#FEE738;" valign="middle"> <a href="\(formUrl)" style="display:inline-block;background:#FFE81F;color:black;font-family:Helvetica;font-size:16px;font-weight:normal;line-height:120%;margin:0;text-decoration:none;text-transform:none;padding:10px 25px;mso-padding-alt:0px;border-radius:3px;" target="_blank"> <b>Wünsche angeben</b> </a> </td></tr></table> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;"> Die Abgabefrist ist am Mittwoch, den 15.02.2023. Falls du bis dahin Deine Meinung ändern solltest und eine Änderung vornehmen möchtest, kannst Du über den Link das Formular erneut ausfüllen. <br></br> Bei Rückfragen kannst Du dich gerne an diese E-Mail-Adresse wenden: \(SECRETS.EMAIL_Address) <br></br> Viele Grüße, <br></br><br></br>Dein Orga-Team </div></td></tr><tr> <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;"> </p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisch generiert und versendet.</div></td></tr></tbody> </table> </div></td></tr></tbody> </table> </div></div></body></html>
"""

		let htmlAttachment = Attachment(htmlContent: htmlMail)

		return Mail(from: EmailManager.senderMail,
					to: [mailUser], //TODO: maybe handle optional
					subject: subject,
					text: textContent,
					attachments: [htmlAttachment]
		)
	}
}
