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
	// TODO: ao und Unbekannt / nicht ball oder asp
	// TODO: Einlasszeit
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
 <div class="centerDiv">
  <a href="***REMOVED***">
   <?xml version="1.0" encoding="UTF-8" standalone="no"?>
   <!DOCTYPE svg
 PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
   <svg width="90%" height="100%" viewBox="0 0 775 464" version="1.1"
 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
 xml:space="preserve" xmlns:serif="http://www.serif.com/"
 style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">
 <g id="Artboard1" transform="matrix(1.20155,0,0,1.02428,-66.0853,-62.4812)">
  <rect x="55" y="61" width="645" height="453" style="fill:none;" />
  <g transform="matrix(0.832258,0,0,0.976293,89.5371,14.1663)">
   <g>
 <path
  d="M618.89,465.32L535.765,310.97C532.003,303.884 524.39,299.509 515.992,299.509L302.312,299.509C299.249,306.247 296.539,312.986 294.085,319.72C288.66,334.857 274.573,344.22 259.437,344.22C255.414,344.22 251.301,343.607 247.273,342.118C236.859,338.357 228.812,330.306 225.136,319.981C222.687,313.067 219.972,306.333 216.824,299.504L184.012,299.504C175.613,299.504 168,303.879 164.239,310.965L81.114,465.325C77.7,471.802 77.965,479.587 81.989,485.712C86.012,491.837 93.278,495.599 100.887,495.599L599.117,495.603C606.73,495.603 613.992,491.841 618.015,485.716C622.038,479.591 622.304,471.802 618.89,465.329L618.89,465.32ZM600.163,475.207L400.753,366.967L356.565,394.268C354.553,395.494 352.276,396.193 350.003,396.193L307.917,396.193L297.679,475.905L262.156,475.905L272.48,396.193L141.93,396.193L157.242,367.67L346.502,367.67L424.814,319.283L477.927,319.283L428.228,349.994L576.628,430.58L600.167,474.244L600.167,475.205L600.163,475.207Z"
  style="fill:white;fill-rule:nonzero;" />
 <path
  d="M249.11,64.926C206.235,69.739 172.11,105.09 168.696,148.137C166.86,172.285 174.384,194.688 188.122,212.012C209.474,238.875 227.673,267.926 240.622,299.512C242.458,303.711 244.036,308 245.61,312.285L245.786,312.637C247.184,316.66 250.337,319.988 254.622,321.562C262.235,324.273 270.634,320.25 273.349,312.637L273.525,312.285C275.099,307.996 276.673,303.711 278.513,299.512C291.462,268.012 309.661,238.875 331.013,212.098C343.349,196.524 350.701,176.836 350.701,155.485C350.701,101.673 304.15,58.797 249.111,64.923L249.11,64.926ZM259.61,211.836C228.462,211.836 203.258,186.547 203.258,155.484C203.258,124.421 228.457,99.132 259.61,99.132C290.758,99.132 315.872,124.331 315.872,155.484C315.872,186.632 290.673,211.836 259.61,211.836Z"
  style="fill:white;fill-rule:nonzero;" />
   </g>
  </g>
 </g>
   </svg>
  </a>
 </div>

   </td>
  </tr>
  <tr>
   <th class="tg-0lax big" colspan="2">Historische ***REMOVED*** ***REMOVED***</th>
  </tr>
  <tr>
   <td class="tg-0lax title">Datum:</td>
   <td class="tg-0lax title">Einlass:</td>
   <td class="tg-0lax" rowspan="2">
 <a href="https://drive.google.com/uc?export=download&id=1RXZxiI5mnAkmOyJDljMjUF1RPM-omqKF">
  <div class="centerDiv">
   <?xml version="1.0" encoding="UTF-8" standalone="no"?>
   <!DOCTYPE svg
 PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
   <svg width="60%" height="100%" viewBox="0 0 303 297" version="1.1"
 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
 xml:space="preserve" xmlns:serif="http://www.serif.com/"
 style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">
 <g transform="matrix(1,0,0,1,-221.192,-151.201)">
  <g>
   <path
 d="M450.8,302.4C410.593,302.4 377.999,334.994 377.999,375.201C377.999,415.408 410.593,448.002 450.8,448.002C491.007,448.002 523.601,415.408 523.601,375.201C523.601,334.994 491.007,302.4 450.8,302.4ZM450.8,425.6C422.964,425.6 400.402,403.038 400.402,375.202C400.402,347.366 422.964,324.804 450.8,324.804C478.636,324.804 501.198,347.366 501.198,375.202C501.198,403.038 478.636,425.6 450.8,425.6ZM484.398,375.198C484.398,378.288 481.894,380.8 478.796,380.8L450.796,380.8C447.699,380.8 445.195,378.292 445.195,375.198L445.195,341.596C445.195,338.506 447.699,335.994 450.796,335.994C453.894,335.994 456.398,338.502 456.398,341.596L456.398,369.596L478.796,369.596C481.898,369.6 484.398,372.108 484.398,375.198L484.398,375.198ZM333.198,324.8L366.8,324.8L366.8,358.402L333.198,358.402L333.198,324.8ZM243.6,380.8L243.6,246.4L456.4,246.4L456.4,291.478C464.213,291.994 471.716,293.568 478.798,296.076L478.798,201.603C478.798,195.415 473.786,190.404 467.599,190.404L433.997,190.404L433.997,168.006C433.997,158.744 426.458,151.205 417.196,151.205C407.934,151.205 400.395,158.744 400.395,168.006L400.395,190.404L299.595,190.4L299.595,168.002C299.595,158.74 292.056,151.201 282.794,151.201C273.532,151.201 265.993,158.74 265.993,168.002L265.993,190.4L232.391,190.4C226.204,190.4 221.192,195.411 221.192,201.599L221.192,391.999C221.192,398.186 226.204,403.198 232.391,403.198L371.671,403.198C369.163,396.112 367.589,388.608 367.073,380.8L243.6,380.8ZM411.6,168C411.6,164.914 414.108,162.398 417.202,162.398C420.291,162.398 422.803,164.914 422.803,168L422.803,201.602C422.803,204.688 420.295,207.204 417.202,207.204C414.112,207.204 411.6,204.688 411.6,201.602L411.6,168ZM277.2,168C277.2,164.914 279.708,162.398 282.802,162.398C285.891,162.398 288.403,164.914 288.403,168L288.403,201.602C288.403,204.688 285.895,207.204 282.802,207.204C279.712,207.204 277.2,204.688 277.2,201.602L277.2,168ZM366.802,302.4L333.2,302.4L333.2,268.798L366.802,268.798L366.802,302.4ZM299.603,302.4L266.001,302.4L266.001,268.798L299.603,268.798L299.603,302.4ZM266.001,324.802L299.603,324.802L299.603,358.404L266.001,358.404L266.001,324.802ZM400.401,302.4L400.401,268.798L434.003,268.798L434.003,292.884C425.066,294.697 416.675,297.99 409.015,302.4L400.401,302.4Z"
 style="fill:white;fill-rule:nonzero;" />
  </g>
 </g>
   </svg>
  </div>
 </a>
   </td>
  </tr>
  <tr>
   <th class="tg-0lax big">Dienstag, 21.06.2023</th>
   <th class="tg-0lax big">16:30</th>
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
