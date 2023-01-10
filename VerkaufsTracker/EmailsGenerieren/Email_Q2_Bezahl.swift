//
//  Q2er_GenerateBezahlEmail.swift
//  
//
//  Created by Benedict on 05.01.23.
//

import Foundation
import SwiftSMTP

extension Q2er {
	internal func generateBezahlEmailInternal(ao: AktionObserver? = nil) -> Mail? {
		guard let mailUser = mailUser else {
			ao?.log("err: \(name); no mail user")
			return nil
		}
		
		let subject = "Deine Bestellungen für die Abi-Feierlichkeiten"

		// TODO: Text überschreiben
		let textContent = """
   Hallo \(vorname),

   Viele Grüße,
   das Orga-Team

   [Diese Email wurde automatisch generiert und versendet.]
   """

		var tableContent = ""

		for itemType in [Item.ball_ticket, .after_show_ticket, .buch, .pulli] {
			let value = bestellungen[itemType, default: 0]
			if value == 0 {
				continue
			}

			tableContent += """
  <tr>
   <td style="padding: 0 15px 0 0;" align="left">\(value)x</td>
   <td style="padding: 0 " align="left">\(itemType.rechnungsPosition)</td>
   <th style="padding: 0 0 0 15px;"align="right">\(preisFuerItem(item: itemType, count: value).geldStr)</th>
  </tr>
  """


			if itemType == .pulli {
				// TODO: haben wir unendlich pullis also ist wunsche == bestellung

				let pulli_xs = Int(self.extraFields[.pulli_xs] ?? "0") ?? 0
				let pulli_s = Int(self.extraFields[.pulli_s] ?? "0") ?? 0
				let pulli_m = Int(self.extraFields[.pulli_m] ?? "0") ?? 0
				let pulli_l = Int(self.extraFields[.pulli_l] ?? "0") ?? 0
				let pulli_xl = Int(self.extraFields[.pulli_xl] ?? "0") ?? 0

				let summe = pulli_xs+pulli_s+pulli_m+pulli_l+pulli_xl

				if summe != value {
					ao?.log("Fehler: \(name): Pulli Aufteilung falsch")
					print("pulli aufteilung falsch")
					return nil
				}

				if pulli_xs != 0 {
					let GK = "XS"
					tableContent += """
<tr><td style="padding: 0 15px 0 0;" align="left"></td><td style="padding: 0 " align="left"><i>\(pulli_xs)x \(pulliGRPosition.replacingOccurrences(of: "§", with: GK))</i></td><th style="padding: 0 0 0 15px;"align="right"></th></tr>
"""
				}

				if pulli_s != 0 {
					let GK = "S"
					tableContent += """
<tr><td style="padding: 0 15px 0 0;" align="left"></td><td style="padding: 0 " align="left"><i>\(pulli_s)x \(pulliGRPosition.replacingOccurrences(of: "§", with: GK))</i></td><th style="padding: 0 0 0 15px;"align="right"></th></tr>
"""
				}

				if pulli_m != 0 {
					let GK = "M"
					tableContent += """
<tr><td style="padding: 0 15px 0 0;" align="left"></td><td style="padding: 0 " align="left"><i>\(pulli_m)x \(pulliGRPosition.replacingOccurrences(of: "§", with: GK))</i></td><th style="padding: 0 0 0 15px;"align="right"></th></tr>
"""
				}

				if pulli_l != 0 {
					let GK = "L"
					tableContent += """
<tr><td style="padding: 0 15px 0 0;" align="left"></td><td style="padding: 0 " align="left"><i>\(pulli_xl)x \(pulliGRPosition.replacingOccurrences(of: "§", with: GK))</i></td><th style="padding: 0 0 0 15px;"align="right"></th></tr>
"""
				}

				if pulli_xl != 0 {
					let GK = "XL"
					tableContent += """
<tr><td style="padding: 0 15px 0 0;" align="left"></td><td style="padding: 0 " align="left"><i>\(pulli_xl)x \(pulliGRPosition.replacingOccurrences(of: "§", with: GK))</i></td><th style="padding: 0 0 0 15px;"align="right"></th></tr>
"""
				}
			}
		}

		var zusatzText = "<br></br> Leider müssen wir dir mitteilen, dass aufgrund der begrenzten Kapatzitäten der ***REMOVED*** nicht genug Tickets verfügbar waren, damit Du Deine gesammte Wunschanzahl erhälst."

		// TODO: wenn wir nicht unendlich pullis bücher haben
		
		if wuenschBestellungen[.ball_ticket, default: 0] != bestellungen[.ball_ticket, default: 0] {
			if wuenschBestellungen[.after_show_ticket, default: 0] != bestellungen[.after_show_ticket, default: 0] {
				// BEIDE
				zusatzText += "Du wolltest \(wuenschBestellungen[.ball_ticket, default: 0]) Ball-Tickets haben, bedauerlicherweise können wir dir nur \(bestellungen[.ball_ticket, default: 0]) Ball-Tickets zusichern. Ebenso sind nur \(bestellungen[.after_show_ticket, default: 0]) After-Show-Party Tickets verfügbar, obwohl Du \(wuenschBestellungen[.after_show_ticket, default: 0]) After-Show-Party Tickets haben wolltest."
			} else {
				// NUR Ball
				zusatzText += "Du wolltest \(wuenschBestellungen[.ball_ticket, default: 0]) Ball-Tickets haben, bedauerlicherweise können wir dir nur \(bestellungen[.ball_ticket, default: 0]) Ball Tickets zusichern."
			}
		} else if wuenschBestellungen[.after_show_ticket, default: 0] != bestellungen[.after_show_ticket, default: 0] {
			// ASP
			zusatzText += "Du wolltest \(wuenschBestellungen[.after_show_ticket, default: 0]) After-Show-Party Tickets haben, bedauerlicherweise können wir dir nur \(bestellungen[.after_show_ticket, default: 0]) After-Show-Party Tickets zusichern."
		} else {
			// Alles verfügbar
			zusatzText = ""
		}



		// TODO: fix dark mode
		let htmlTemplate = """
 <!doctype html><html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office"><head><title></title><!--[if !mso]><!--><meta http-equiv="X-UA-Compatible" content="IE=edge"><!--<![endif]--><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="color-scheme" content="light dark"/><meta name="supported-color-schemes" content="light dark"/> <style type="text/css"> @media (prefers-color-scheme: dark){.darkmode{background-color: #111111;}.darkmode h1, .darkmode p, .darkmode span, .darkmode a{color: #ffffff;}}</style><style type="text/css">#outlook a { padding:0; }
		   body { margin:0;padding:0;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%; }
		   table, td { border-collapse:collapse;mso-table-lspace:0pt;mso-table-rspace:0pt; }
		   img { border:0;height:auto;line-height:100%; outline:none;text-decoration:none;-ms-interpolation-mode:bicubic; }
		   p { display:block;margin:13px 0; }</style><!--[if mso]>
		 <noscript>
		 <xml>
		 <o:OfficeDocumentSettings>
		   <o:AllowPNG/>
		   <o:PixelsPerInch>96</o:PixelsPerInch>
		 </o:OfficeDocumentSettings>
		 </xml>
		 </noscript>
		 <![endif]--><!--[if lte mso 11]>
		 <style type="text/css">
		   .mj-outlook-group-fix { width:100% !important; }
		 </style>
		 <![endif]--><!--[if !mso]><!--><!--<![endif]--><style type="text/css">@media only screen and (min-width:480px) {
		 .mj-column-per-100 { width:100% !important; max-width: 100%; }
	   }</style><style media="screen and (min-width:480px)">.moz-text-html .mj-column-per-100 { width:100% !important; max-width: 100%; }</style><style type="text/css">@media only screen and (max-width:480px) {
	   table.mj-full-width-mobile { width: 100% !important; }
	   td.mj-full-width-mobile { width: auto !important; }
  }</style></head><body style="word-spacing:normal;background-color:#000000;"><div style="background-color:#000000;"><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]--><div style="margin:0px auto;max-width:600px;"><table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;"><tbody><tr><td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;"><!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]--><div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;"><table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%"><tbody><tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;">
                          <tbody>
                            <tr>
                              <td style="width:100px;">
        <img height="auto" src="\(EmailManager.headerImage)" style="border:0;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" width="100" />
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr><tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <p style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:100%;">
                        </p>
                        <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;
</td></tr></table><![endif]-->
                      </td>
                    </tr><tr>
                      <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FFE81F;">Hallo \(vorname),</div>
                      </td>
                    </tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Danke, dass Du uns Deine Wünsche für die Abifeierlichkeiten zugesendet hast.<br></br<\(zusatzText)<br><br>Hier nochmal eine Übersicht über Deine Bestellung:</div></td></tr></tbody></table></td></tr><tr><td style="font-size:0px;word-break:break-word;"><div style="height:20px;line-height:20px;">&#8202;</div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;"><b>Bestellungsübersicht</b></div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><table cellpadding="0" cellspacing="0" width="100%" border="0" style="color:white;font-family:Ubuntu, Helvetica, Arial, sans-serif;font-size:13px;line-height:22px;table-layout:auto;width:100%;border:none;">\(tableContent)<tr style="border-top: thin solid;"><th colspan="2" align="left">Zusammen:</th><th align="right">\(zuzahlenderBetrag.geldStr)</th></tr></table></td></tr><tr><td style="font-size:0px;word-break:break-word;"><div style="height:20px;line-height:20px;">&#8202;</div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;"><b>Zahlungsinformationen</b></div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><table cellpadding="0" cellspacing="0" width="100%" border="0" style="color:white;font-family:Ubuntu, Helvetica, Arial, sans-serif;font-size:13px;line-height:22px;table-layout:auto;width:100%;border:none;"><tr><th colspan="2" align="left">Empfänger:</th><td align="right">***REMOVED*** ***REMOVED***</td></tr><tr><th colspan="2" align="left">IBAN:</th><td align="right">DE32 3305 0000 000 13454 79 </td></tr><tr><th colspan="2" align="left">Zweck:</th><td align="right">Abi 2023 \(vorname) \(nachname) \(formID)</td></tr><tr><th colspan="2" align="left">Betrag:</th><td align="right">\(zuzahlenderBetrag.geldStr)</td></tr></table></td></tr><tr><td style="font-size:0px;word-break:break-word;"><div style="height:20px;line-height:20px;">&#8202;</div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Bitte überweise bis zum 30.04.2022 den Betrag auf unser Abi-Konto.</div></td></tr>
<tr><td style="font-size:0px;word-break:break-word;"><div style="height:20px;line-height:20px;">&#8202;</div></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:helvetica;font-size:16px;line-height:1;text-align:left;color:white;">Bei Rückfragen kannst Du dich gerne an diese E-Mail-Adresse wenden: \(SECRETS.EMAIL_Address)<br></br><br></br>Viele Grüße, <br></br> Dein Orga-Team</div></td></tr><tr><td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;"><p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;"></p><!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;
 </td></tr></table><![endif]--></td></tr><tr><td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;"><div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisch generiert und versendet.</div></td></tr></tbody></table></div><!--[if mso | IE]></td></tr></table><![endif]--></td></tr></tbody></table></div><!--[if mso | IE]></td></tr></table><![endif]--></div></body></html>
"""

		let htmlAttachment = Attachment(htmlContent: htmlTemplate)

		return Mail(from: EmailManager.senderMail,
					to: [mailUser], //TODO: maybe handle optional
					subject: subject,
					text: textContent,
					attachments: [htmlAttachment]
		)
	}
}
