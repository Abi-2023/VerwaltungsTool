//
//  TicketRenderer.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI
import Foundation
import UIKit
import QRCodeGenerator

extension Ticket {
	func ticketHTML(verwaltung v: Verwaltung) -> String {
		let vt = VerifyTicket()
		let qrText = vt.createToken(ticketId: self.id)

		let qr = try! QRCode.encode(text: qrText, ecl: .medium)
		let svg = qr.toSVGString(border: 10, width: 600, foreground: "#FFF", background: "#00000000")

		let nrColor = [
			"#FFDF00", //gelb
			"#3D8FF5", //blau
			"#67E80C", //froschgrün
			"#A103FF", //lila
			"#E83633", //rot
			"#FE8100", //organge
			"#FF38EE", //pink
			"#3679FF", //dunkelblau
			"#00DDFF", //cyan
			"#09B31D" //dunkelgrün
		][safe: nth] ?? "#09B31D"

		let nrText = "\(nth)".count == 1 ? "0\(nth)" : "\(nth)"
		let name = v.personen.first(where: {$0.id == owner})?.name ?? "Unbekannt"


		let htlmstr = """
<!DOCTYPE html>
<html lang="de">

<head>
 <meta charset="UTF-8">
</head>


<body style="width: 100%; height: 100%; margin: 0px;">



 <div class="wrap-layer">
  <!-- <div class="text-layer" style="margin-top: 250px">
   <p style="color: red;">Hello</p>
  </div> -->

  <div class="text-layer" style="margin-top: 380px; text-align: center;">
\(svg)
  </div>


  <div class="text-layer" style="margin-top: 180px; margin-left: 20px;">
   <style type="text/css">
 .tg {
  border-collapse: collapse;
  border-spacing: 0;
 }

 .tg td {
  border-color: red;
  /* border-style: solid; */
  border-width: 1px;
  font-family: 'DIN Alternate', sans-serif;
  overflow: hidden;
  padding-left: 5px;
  padding-top: 15px;
  padding-bottom: 0px;
  word-break: normal;
 }

 .tg th {
  border-color: red;
  /* border-style: solid; */
  border-width: 1px;
  font-family: 'DIN Alternate', sans-serif;
  font-weight: normal;
  overflow: hidden;
  padding-left: 5px;
  padding-top: 2px;
  padding-bottom: 0px;
  word-break: normal;
 }

 .tg .tg-0lax {
  text-align: left;
  vertical-align: top
 }

 .title {
  font-size: 16px;
 }

 .big {
  font-size: 25px;
 }

 .huge {
  font-size: 30px;
 }

 .centerDiv {
  text-align: center;
 }
   </style>
   <table class="tg" style="color: white; table-layout: fixed; width: 600px; font-family: 'DIN Alternate';">
 <colgroup>
  <col style="width: 400px">
  <col style="width: 100px">
  <col style="width: 100px">
 </colgroup>
 <tbody>
  <tr>
   <td class="tg-0lax title" colspan="2">Bestellt von:</td>
   <td class="tg-0lax title">
 <div class="centerDiv">Ticket Nr.</div>
   </td>
  </tr>
  <tr>
   <th class="tg-0lax huge" colspan="2">\(name)</th>
   <th class="tg-0lax huge">
 <div class="centerDiv" style="color: \(nrColor); font-size: 55px;">\(nrText)</div>
   </th>
  </tr>
  <tr>
   <td class="tg-0lax title" colspan="2">Veranstaltungsort:</td>
   <td class="tg-0lax title" rowspan="2">
 

   </td>
  </tr>
  <tr>
   <th class="tg-0lax big" colspan="2">Historische ***REMOVED*** ***REMOVED***</th>
  </tr>
  <tr>
   <td class="tg-0lax title" colspan="2">Datum:</td>
   <td class="tg-0lax" rowspan="2">
   </td>
  </tr>
  <tr>
   <th class="tg-0lax big">Mittwoch, 21.06.2023 | 17:00</th>
  </tr>
 </tbody>
   </table>
  </div>

  <div class="text-layer" style="margin-top: 890px; width: 100vw; text-align: center; font-family: 'DIN Alternate', sans-serif; font-size: 16; color: white">
 ID: \(id)
</div>

  <div class="background-layer">
\(itemType == .after_show_ticket ? ASPTicketBackground : BallTicketBackground)

  </div>
 </div>
</body>

<style>
 .wrap-layer {
  position: relative;
 }

 .text-layer {
  position: absolute;

  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  margin: 0;
  /* non-critical styles left out */
 }
</style>

</html>
"""
		return htlmstr
	}
}

class CustomPrintPageRenderer: UIPrintPageRenderer {

	let A4PageWidth: CGFloat = 500

	let A4PageHeight: CGFloat = 1000

	override init() {
		super.init()

		// Specify the frame of the A4 page.
		let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)

		// Set the page frame.
		self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")

		// Set the horizontal and vertical insets (that's optional).
		self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")

	}


	func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
		let data = NSMutableData()

		UIGraphicsBeginPDFContextToData(data, CGRect(x: 0, y: 0, width: 500, height: 1000), nil)

		UIGraphicsBeginPDFPageWithInfo(paperRect, nil)

		printPageRenderer.drawPage(at: 0, in: paperRect)

		UIGraphicsEndPDFContext()

		return data
	}

 func exportHTMLContentToPDF(HTMLContent: String) {
	 let url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.appendingPathComponent("Ticket_\(Int.random(in: 0...99999)).pdf")
	 let pdfFilename = url.absoluteString
	 let data = exportHTMLContentToPDFData(HTMLContent: HTMLContent)
	 try! data.write(to: url)

	 print(pdfFilename)
 }


	func exportHTMLContentToPDFData(HTMLContent: String) -> Data{
		let printPageRenderer = CustomPrintPageRenderer()

		let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
		printFormatter.perPageContentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		printFormatter.maximumContentHeight = 1000
		printFormatter.maximumContentWidth = 500
		printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

		let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)

		let data = pdfData! as Data
		return data
	}

}
