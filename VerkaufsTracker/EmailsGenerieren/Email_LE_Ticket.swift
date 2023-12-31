//
//  Email_LE_Ticket.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation
import SwiftSMTP

extension Lehrer {
	internal func generateTicketEmailInternal(v: Verwaltung, ao: AktionObserver? = nil) -> Mail? {
		let subject = "Tickets für die Abi-Feierlichkeiten 2023"

		let anrede = "\(weiblich ? "Sehr geehrte Frau" : "Sehr geehrter Herr") \(nachname),"

        let htmlText = """
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">

<head>
  <title>
  </title>
  <!--[if !mso]><!-->
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <!--<![endif]-->
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
 <meta name="color-scheme" content="light dark"/><meta name="supported-color-schemes" content="light dark"/> <style type="text/css"> @media (prefers-color-scheme: dark){.darkmode{background-color: #111111;}.darkmode h1, .darkmode p, .darkmode span, .darkmode a{color: #ffffff;}}</style>
  <style type="text/css">
    #outlook a {
      padding: 0;
    }

    body {
      margin: 0;
      padding: 0;
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }

    table,
    td {
      border-collapse: collapse;
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }

    img {
      border: 0;
      height: auto;
      line-height: 100%;
      outline: none;
      text-decoration: none;
      -ms-interpolation-mode: bicubic;
    }

    p {
      display: block;
      margin: 13px 0;
    }
  </style>
  <!--[if mso]>
        <noscript>
        <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
        </xml>
        </noscript>
        <![endif]-->
  <!--[if lte mso 11]>
        <style type="text/css">
          .mj-outlook-group-fix { width:100% !important; }
        </style>
        <![endif]-->
  <style type="text/css">
    @media only screen and (min-width:480px) {
      .mj-column-per-100 {
        width: 100% !important;
        max-width: 100%;
      }
    }
  </style>
  <style media="screen and (min-width:480px)">
    .moz-text-html .mj-column-per-100 {
      width: 100% !important;
      max-width: 100%;
    }
  </style>
  <style type="text/css">
    @media only screen and (max-width:480px) {
      table.mj-full-width-mobile {
        width: 100% !important;
      }

      td.mj-full-width-mobile {
        width: auto !important;
      }
    }
  </style>
</head>

<body style="word-spacing:normal;background-color:#000000;">
  <div style="background-color:#000000;">
    <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:20px 0;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
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
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <p style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:100%;">
                        </p>
                        <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 4px gray;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;
</td></tr></table><![endif]-->
                      </td>
                    </tr>
                    <tr>
                      <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <div style="font-family:Helvetica;font-size:19px;font-weight:bold;line-height:1;text-align:left;color:#FFE81F;">\(anrede)</div>
                      </td>
                    </tr>
                    <tr>
                      <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <div style="font-family:Helvetica;font-size:16px;line-height:1;text-align:left;color:white;">
Im Namen der gesamten Stufe wollen wir Ihnen mitteilen, dass wir uns sehr freuen, Ihnen die Tickets für unseren bevorstehenden Abiball zukommen zu lassen.
<br><br>
Der Einlass für den Abiball findet am 21.06.2023 in der <a style="color: #0082ED" href="">  </a> um 16:30 statt. <br>Im Anschluss (gegen 00:30) beginnt dann die After Show Party.
Um den Prozess möglichst effizient und umweltfreundlich zu gestalten, senden wir Ihnen die Tickets als PDF zu. Bitte überprüfen Sie Ihren Anhang und stellen Sie sicher, dass Sie die Tickets korrekt erhalten haben. Jedes Ticket ist personalisiert und am Abend einmal einlösbar. Bitte beachten Sie, dass wir am Eingang des Abiballs die Tickets scannen werden, um den Zugang zu gewährleisten. Wir bitten Sie daher, Ihr Ticket entweder in digitaler Form auf Ihrem Mobilgerät bereitzuhalten oder alternativ auszudrucken.
<br>
Falls Sie Fragen oder Anliegen bezüglich des Abiballs oder der Tickets haben, stehen wir Ihnen gerne zur Verfügung.
<br><br>
Wir freuen uns, diesen besonderen Abend mit Ihnen und unseren Freunden verbringen zu können.
<br><br>
Mit freundlichen Grüßen,
<br>
Die Q2<br>
c/o Anh & Benedict
</div>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <p style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:100%;">
                        </p>
                        <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 1px #E0E0E0A0;font-size:1px;margin:0px auto;width:550px;" role="presentation" width="550px" ><tr><td style="height:0;line-height:0;"> &nbsp;
</td></tr></table><![endif]-->
                      </td>
                    </tr>
                    <tr>
                      <td align="left" style="font-size:0px;padding:10px 25px;word-break:break-word;">
                        <div style="font-family:helvetica;font-size:13px;line-height:1;text-align:left;color:grey;">Diese Email wurde automatisiert generiert und versendet.</div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!--[if mso | IE]></td></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!--[if mso | IE]></td></tr></table><![endif]-->
  </div>
</body>

</html>

"""

		let htmlAttachment = Attachment(htmlContent: htmlText)
		var attachments: [Attachment] = [htmlAttachment]

		for ticket in tickets {
			attachments.append(ticket.generateAttatchment(verwaltung: v))
		}

		guard let mailUser = mailUser else {
			return nil
		}

		let mail = Mail(
			from: EmailManager.senderMail,
			to: [mailUser],
			subject: subject,
			attachments: attachments
		)

		return mail
	}
}
