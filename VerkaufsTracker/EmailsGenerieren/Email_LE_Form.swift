//
//  Email_LE_Form.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation
import SwiftSMTP

extension Lehrer {
	internal func generateFormEmailInternal(ao: AktionObserver? = nil) -> Mail? {
		guard let mailUser = mailUser else {
			ao?.log("err: \(name); no mail user")
			return nil
		}
		let subject = "Ihre Einladung zu den Abi-Feierlichkeiten der Q2"

		let formName = formName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Name"
		let formUrl = "***REMOVED***/viewform?usp=pp_url&entry.514969491=\(formID)&entry.843812046=\(formName)"

		let anrede = "\(weiblich ? "Sehr geehrte Frau" : "Sehr geehrter Herr") \(nachname)"

		let textContent = """

   Sehr geehrte/Sehr geehrter \(name),

   Wir, der Abitur-Jahrgang 2023, danken Ihnen für Ihre Begleitung unserer Schullaufbahn und laden Sie ganz herzlich auf unsere Abi-Feierlichkeiten ein. Damit wir allerdings die Events strukturiert planen können, brauchen wir Ihre Angaben und Wünsche.

   Mit dem unten stehenden Link gelangen Sie zu einem Google-Formular, wo Sie sich eintragen können, wie viele
   ⁃ Tickets für den Abiball (ca. 50-60€)
   ⁃ Tickets für die After-Show-Party (ca. 10–15€)
   ⁃ Abibücher (ca. 15-20€)
   ⁃ Abipullis (ca. 25-40€)
   Sie sich gerne wünschen.

   \(formUrl)

   Nachdem wir die Wünsche von allen Schüler*innen und Lehrer*innen erfasst haben, können wir die Festpreise kalkulieren und Ihnen Informationen über den Bezahlungsvorgang schicken.

   Bei Fragen können Sie sich an diese Email wenden: \(SECRETS.EMAIL_Address)

   Wir freuen uns schon mit Ihnen unsere letzten Tage als Schüler zu feiern.

   Viele Grüße,
   Das Abi-Orga-Team

   [Diese Email wurde automatisch generiert und versendet.]
   """

        let htmlMail = """
 <!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head> <title></title> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1"><meta name="color-scheme" content="light dark"/><meta name="supported-color-schemes" content="light dark"/> <style type="text/css"> @media (prefers-color-scheme: dark){.darkmode{background-color: #111111;}.darkmode h1, .darkmode p, .darkmode span, .darkmode a{color: #ffffff;}}</style> <style type="text/css"> #outlook a{padding: 0;}body{margin: 0; padding: 0; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%;}table, td{border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt;}img{border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; -ms-interpolation-mode: bicubic;}p{display: block; margin: 13px 0;}</style><!--[if mso]> <noscript> <xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml> </noscript><![endif]--><!--[if lte mso 11]> <style type="text/css"> .mj-outlook-group-fix{width:100% !important;}</style><![endif]--> <style type="text/css"> @media only screen and (min-width:480px){.mj-column-per-100{width: 100% !important; max-width: 100%;}}</style> <style media="screen and (min-width:480px)"> .moz-text-html .mj-column-per-100{width: 100% !important; max-width: 100%;}</style> <style type="text/css"> @media only screen and (max-width:480px){table.mj-full-width-mobile{width: 100% !important;}td.mj-full-width-mobile{width: auto !important;}}</style></head><body style="word-spacing:normal;background-color:#000000;"> <div style="background-color:#000000;"> <div style="margin:0px auto;max-width:600px;"> <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"> <tbody> <tr> <td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"> <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"> <tbody><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;"><tbody><tr><td style="width:100px;"><img height="auto" src="\(EmailManager.headerImage)" style="border:0;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" width="100" /></td></tr></tbody></table></td></tr><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><p style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:100%;"></p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FFE81F;">\(anrede),</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;"> Wir, der Abitur-Jahrgang 2023, danken Ihnen für Ihre Begleitung unserer Schullaufbahn und laden Sie ganz herzlich auf unsere Abi-Feierlichkeiten ein. Damit wir allerdings die Events strukturiert planen können, brauchen wir Ihre Angaben und Wünsche.<br></br>
   <br></br>
   Mit dem unten stehenden Button gelangen Sie zu einem Google-Formular, wo Sie sich eintragen können, wie viele<br></br>
   ⁃ Tickets für den Abiball (ca. 50-60€ pro Person)<br></br>
   ⁃ Tickets für die After-Show-Party (ca. 10–15€ pro Person)<br></br>
   ⁃ Abibücher (ca. 15-20€ pro Stück)<br></br>
   ⁃ Abipullis (ca. 30-50€ pro Stück)<br></br>
   Sie sich gerne wünschen.<br></br>
</div></td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:Helvetica;font-size:14px;line-height:1;text-align:left;color:grey;">Der Link ist für jede Lehrkraft individuell. Teilen Sie diesen daher bitte nicht mit anderen.</div></td></tr><tr> <td align="center" vertical-align="middle" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:separate;line-height:100%;"> <tr> <td align="center" bgcolor="#FEE738" role="presentation" style="border:none;border-radius:3px;cursor:auto;mso-padding-alt:10px 25px;background:#FEE738;" valign="middle"> <a href="\(formUrl)" style="display:inline-block;background:#FFE81F;color:black;font-family:Helvetica;font-size:16px;font-weight:normal;line-height:120%;margin:0;text-decoration:none;text-transform:none;padding:10px 25px;mso-padding-alt:0px;border-radius:3px;" target="_blank"> <b>Wünsche angeben</b> </a> </td></tr></table> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Die Abgabefrist ist am Dienstag, den 31.01.2023. Falls Sie bis dahin Ihre Meinung ändern sollten und eine Änderung vornehmen möchten, können Sie über den Link das Formular erneut ausfüllen. Nachdem wir die Wünsche von allen Schüler*innen und Lehrer*innen erfasst haben, können wir die Festpreise kalkulieren und Ihnen Informationen über den Bezahlungsvorgang schicken.<br></br> Bei Rückfragen können Sie sich gerne an folgende E-Mail-Adresse wenden: \(SECRETS.EMAIL_Address) <br></br> <br></br> Viele Grüße, <br>Die Q2 </div></td></tr><tr> <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;"> </p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;</td></tr></table><![endif]--> </td></tr><tr> <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"> <div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisch generiert und versendet.</div></td></tr></tbody> </table> </div></td></tr></tbody> </table> </div></div></body></html>
"""


		let htmlAttachment = Attachment(htmlContent: htmlMail)

		return Mail(from: EmailManager.senderMail,
					to: [mailUser],
					subject: subject,
					text: textContent,
					attachments: [htmlAttachment]
		)
	}
}
