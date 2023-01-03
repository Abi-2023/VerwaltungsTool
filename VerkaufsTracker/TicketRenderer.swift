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
		let qrText = vt.signatureForId(id: self.id)

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
   <?xml version="1.0" encoding="UTF-8" standalone="no"?>
   <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg
 width="100%" height="100%" viewBox="0 0 500 1000" version="1.1" xmlns="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" xmlns:serif="http://www.serif.com/"
 style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">
 <rect id="Background" x="0" y="0" width="500" height="1000" style="fill:none;" />
 <clipPath id="_clip1">
  <rect x="0" y="0" width="500" height="1000" />
 </clipPath>
 <g clip-path="url(#_clip1)">
  <rect x="0" y="-0" width="503" height="1003" />
  <g>
   <ellipse cx="107.613" cy="99.806" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="219.732" cy="103.799" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="300.777" cy="108.004" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="60.111" cy="158.941" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="83.835" cy="142.745" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="207.171" cy="128.478" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="43.866" cy="146.013" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="335.893" cy="62.755" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="253.182" cy="117.464" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="380.037" cy="173.446" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="210.413" cy="4.452" rx="0.554" ry="0.554" style="fill:#fff;" />
   <ellipse cx="341.513" cy="173.539" rx="0.467" ry="0.467" style="fill:#fff;" />
   <ellipse cx="307.438" cy="138.082" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="404.967" cy="130.704" rx="0.583" ry="0.583" style="fill:#fff;" />
   <ellipse cx="41.111" cy="36.046" rx="0.662" ry="0.662" style="fill:#fff;" />
   <ellipse cx="268.268" cy="154.994" rx="0.491" ry="0.491" style="fill:#fff;" />
   <ellipse cx="389.642" cy="171.054" rx="0.576" ry="0.576" style="fill:#fff;" />
   <ellipse cx="470.774" cy="115.966" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="97.193" cy="175.425" rx="0.378" ry="0.378" style="fill:#fff;" />
   <ellipse cx="123.414" cy="123.795" rx="0.46" ry="0.46" style="fill:#fff;" />
   <ellipse cx="122.592" cy="136.814" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="498.368" cy="75.381" rx="0.251" ry="0.251" style="fill:#fff;" />
   <ellipse cx="486.892" cy="172.633" rx="0.67" ry="0.67" style="fill:#fff;" />
   <ellipse cx="248.221" cy="110.674" rx="0.256" ry="0.256" style="fill:#fff;" />
   <ellipse cx="24.637" cy="135.827" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="260.987" cy="83.24" rx="0.245" ry="0.245" style="fill:#fff;" />
   <ellipse cx="194.417" cy="47.243" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="17.006" cy="114.017" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="390.997" cy="50.287" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="149.01" cy="47.107" rx="0.433" ry="0.433" style="fill:#fff;" />
   <ellipse cx="445.995" cy="32.133" rx="0.636" ry="0.636" style="fill:#fff;" />
   <ellipse cx="193.72" cy="160.117" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="3.083" cy="88.394" rx="0.624" ry="0.624" style="fill:#fff;" />
   <ellipse cx="201.88" cy="28.987" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="478.763" cy="130.34" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="162.878" cy="60.196" rx="0.438" ry="0.438" style="fill:#fff;" />
   <ellipse cx="1.736" cy="13.317" rx="0.542" ry="0.542" style="fill:#fff;" />
   <ellipse cx="436.316" cy="162.914" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="184.091" cy="79.69" rx="0.415" ry="0.415" style="fill:#fff;" />
   <ellipse cx="428.613" cy="10.66" rx="0.456" ry="0.456" style="fill:#fff;" />
   <ellipse cx="234.104" cy="23.981" rx="0.412" ry="0.412" style="fill:#fff;" />
   <ellipse cx="481.667" cy="139.987" rx="0.565" ry="0.565" style="fill:#fff;" />
   <ellipse cx="184.138" cy="100.303" rx="0.401" ry="0.401" style="fill:#fff;" />
   <ellipse cx="380.511" cy="5.637" rx="0.41" ry="0.41" style="fill:#fff;" />
   <ellipse cx="207.641" cy="139.555" rx="0.56" ry="0.56" style="fill:#fff;" />
   <ellipse cx="122.415" cy="38.565" rx="0.584" ry="0.584" style="fill:#fff;" />
   <ellipse cx="306.039" cy="127.853" rx="0.647" ry="0.647" style="fill:#fff;" />
   <ellipse cx="112.86" cy="162.079" rx="0.602" ry="0.602" style="fill:#fff;" />
   <ellipse cx="99.684" cy="96.052" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="389.158" cy="41.323" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="456.224" cy="12.325" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="343.805" cy="160.315" rx="0.522" ry="0.522" style="fill:#fff;" />
   <ellipse cx="1.492" cy="161.69" rx="0.667" ry="0.667" style="fill:#fff;" />
   <ellipse cx="500.693" cy="32.402" rx="0.545" ry="0.545" style="fill:#fff;" />
   <ellipse cx="500.455" cy="165.253" rx="0.62" ry="0.62" style="fill:#fff;" />
   <ellipse cx="479.654" cy="158.039" rx="0.261" ry="0.261" style="fill:#fff;" />
   <ellipse cx="286.928" cy="27.998" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="213.081" cy="123.821" rx="0.327" ry="0.327" style="fill:#fff;" />
   <ellipse cx="390.266" cy="32.573" rx="0.551" ry="0.551" style="fill:#fff;" />
   <ellipse cx="150.529" cy="68.708" rx="0.407" ry="0.407" style="fill:#fff;" />
   <ellipse cx="204.58" cy="69.491" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="257.263" cy="169.673" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="76.251" cy="124.271" rx="0.451" ry="0.451" style="fill:#fff;" />
   <ellipse cx="339.076" cy="34.356" rx="0.247" ry="0.247" style="fill:#fff;" />
   <ellipse cx="256.645" cy="118.117" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="121.219" cy="-1.632" rx="0.635" ry="0.635" style="fill:#fff;" />
   <ellipse cx="102.946" cy="48.505" rx="0.414" ry="0.414" style="fill:#fff;" />
   <ellipse cx="195.215" cy="138.74" rx="0.609" ry="0.609" style="fill:#fff;" />
   <ellipse cx="156.19" cy="126.583" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="439.874" cy="116.963" rx="0.463" ry="0.463" style="fill:#fff;" />
   <ellipse cx="493.913" cy="42.949" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="10.772" cy="53.277" rx="0.364" ry="0.364" style="fill:#fff;" />
   <ellipse cx="165.523" cy="120.984" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="105.59" cy="126.343" rx="0.311" ry="0.311" style="fill:#fff;" />
   <ellipse cx="289.454" cy="-0.752" rx="0.405" ry="0.405" style="fill:#fff;" />
   <ellipse cx="445.122" cy="152.661" rx="0.527" ry="0.527" style="fill:#fff;" />
   <ellipse cx="133.436" cy="163.064" rx="0.426" ry="0.426" style="fill:#fff;" />
   <ellipse cx="237.345" cy="165.701" rx="0.499" ry="0.499" style="fill:#fff;" />
   <ellipse cx="407.432" cy="75.439" rx="0.55" ry="0.55" style="fill:#fff;" />
   <ellipse cx="112.364" cy="62.157" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="155.741" cy="91.817" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="259.85" cy="13.003" rx="0.494" ry="0.494" style="fill:#fff;" />
   <ellipse cx="467.748" cy="35.858" rx="0.502" ry="0.502" style="fill:#fff;" />
   <ellipse cx="394.046" cy="125.067" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="435.635" cy="88.421" rx="0.229" ry="0.229" style="fill:#fff;" />
   <ellipse cx="5.214" cy="130.598" rx="0.656" ry="0.656" style="fill:#fff;" />
   <ellipse cx="94.326" cy="174.885" rx="0.51" ry="0.51" style="fill:#fff;" />
   <ellipse cx="116.979" cy="203.373" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="229.102" cy="207.365" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="310.148" cy="211.57" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="216.538" cy="232.045" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="262.552" cy="221.03" rx="0.9" ry="0.9" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="414.338" cy="234.27" rx="0.583" ry="0.583" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="480.144" cy="219.53" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="132.78" cy="227.361" rx="0.46" ry="0.46" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="257.587" cy="214.249" rx="0.256" ry="0.256" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="26.356" cy="217.584" rx="0.595" ry="0.595" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="488.129" cy="233.91" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="193.505" cy="203.871" rx="0.401" ry="0.401" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="315.404" cy="231.418" rx="0.647" ry="0.647" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="109.054" cy="199.614" rx="0.457" ry="0.457" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="222.452" cy="227.386" rx="0.327" ry="0.327" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="85.618" cy="227.839" rx="0.451" ry="0.451" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="266.015" cy="221.677" rx="0.28" ry="0.28" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="165.557" cy="230.154" rx="0.439" ry="0.439" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="449.24" cy="220.527" rx="0.463" ry="0.463" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="174.888" cy="224.559" rx="0.346" ry="0.346" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="114.956" cy="229.92" rx="0.311" ry="0.311" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="403.41" cy="228.634" rx="0.419" ry="0.419" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="14.584" cy="234.162" rx="0.656" ry="0.656" style="fill:#fff;" />
  </g>
  <g>
   <ellipse cx="148.613" cy="112.945" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="260.732" cy="116.938" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="341.777" cy="121.143" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="101.111" cy="172.08" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="124.835" cy="155.884" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="27.096" cy="118.962" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="248.171" cy="141.617" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="84.866" cy="159.152" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="376.893" cy="75.894" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="294.182" cy="130.603" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="421.037" cy="186.585" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="251.413" cy="17.591" rx="0.554" ry="0.554" style="fill:#fff;" />
   <ellipse cx="382.513" cy="186.678" rx="0.467" ry="0.467" style="fill:#fff;" />
   <ellipse cx="348.438" cy="151.221" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="445.967" cy="143.843" rx="0.583" ry="0.583" style="fill:#fff;" />
   <ellipse cx="82.111" cy="49.185" rx="0.662" ry="0.662" style="fill:#fff;" />
   <ellipse cx="309.268" cy="168.133" rx="0.491" ry="0.491" style="fill:#fff;" />
   <ellipse cx="430.642" cy="184.193" rx="0.576" ry="0.576" style="fill:#fff;" />
   <ellipse cx="138.193" cy="188.564" rx="0.378" ry="0.378" style="fill:#fff;" />
   <ellipse cx="164.414" cy="136.934" rx="0.46" ry="0.46" style="fill:#fff;" />
   <ellipse cx="163.592" cy="149.953" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="289.221" cy="123.813" rx="0.256" ry="0.256" style="fill:#fff;" />
   <ellipse cx="463.844" cy="7.054" rx="0.289" ry="0.289" style="fill:#fff;" />
   <ellipse cx="65.637" cy="148.967" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="301.987" cy="96.379" rx="0.245" ry="0.245" style="fill:#fff;" />
   <ellipse cx="235.417" cy="60.382" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="58.006" cy="127.156" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="431.997" cy="63.426" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="369.16" cy="0.879" rx="0.26" ry="0.26" style="fill:#fff;" />
   <ellipse cx="190.01" cy="60.246" rx="0.433" ry="0.433" style="fill:#fff;" />
   <ellipse cx="486.995" cy="45.272" rx="0.636" ry="0.636" style="fill:#fff;" />
   <ellipse cx="234.72" cy="173.256" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="44.083" cy="101.533" rx="0.624" ry="0.624" style="fill:#fff;" />
   <ellipse cx="242.88" cy="42.126" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="8.283" cy="188.845" rx="0.597" ry="0.597" style="fill:#fff;" />
   <ellipse cx="203.878" cy="73.335" rx="0.438" ry="0.438" style="fill:#fff;" />
   <ellipse cx="403.862" cy="7.081" rx="0.453" ry="0.453" style="fill:#fff;" />
   <ellipse cx="42.736" cy="26.457" rx="0.542" ry="0.542" style="fill:#fff;" />
   <ellipse cx="477.316" cy="176.053" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="225.091" cy="92.829" rx="0.415" ry="0.415" style="fill:#fff;" />
   <ellipse cx="469.613" cy="23.799" rx="0.456" ry="0.456" style="fill:#fff;" />
   <ellipse cx="275.104" cy="37.12" rx="0.412" ry="0.412" style="fill:#fff;" />
   <ellipse cx="225.138" cy="113.442" rx="0.401" ry="0.401" style="fill:#fff;" />
   <ellipse cx="421.511" cy="18.776" rx="0.41" ry="0.41" style="fill:#fff;" />
   <ellipse cx="248.641" cy="152.694" rx="0.56" ry="0.56" style="fill:#fff;" />
   <ellipse cx="163.415" cy="51.704" rx="0.584" ry="0.584" style="fill:#fff;" />
   <ellipse cx="347.039" cy="140.992" rx="0.647" ry="0.647" style="fill:#fff;" />
   <ellipse cx="153.86" cy="175.218" rx="0.602" ry="0.602" style="fill:#fff;" />
   <ellipse cx="140.684" cy="109.191" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="430.158" cy="54.462" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="497.224" cy="25.464" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="77.573" cy="7.875" rx="0.379" ry="0.379" style="fill:#fff;" />
   <ellipse cx="384.805" cy="173.454" rx="0.522" ry="0.522" style="fill:#fff;" />
   <ellipse cx="42.492" cy="174.829" rx="0.667" ry="0.667" style="fill:#fff;" />
   <ellipse cx="45.14" cy="5.37" rx="0.535" ry="0.535" style="fill:#fff;" />
   <ellipse cx="327.928" cy="41.137" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="254.081" cy="136.96" rx="0.327" ry="0.327" style="fill:#fff;" />
   <ellipse cx="431.266" cy="45.712" rx="0.551" ry="0.551" style="fill:#fff;" />
   <ellipse cx="191.529" cy="81.847" rx="0.407" ry="0.407" style="fill:#fff;" />
   <ellipse cx="245.58" cy="82.63" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="67.127" cy="-1.237" rx="0.356" ry="0.356" style="fill:#fff;" />
   <ellipse cx="298.263" cy="182.812" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="117.251" cy="137.41" rx="0.451" ry="0.451" style="fill:#fff;" />
   <ellipse cx="380.076" cy="47.495" rx="0.247" ry="0.247" style="fill:#fff;" />
   <ellipse cx="297.645" cy="131.256" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="162.219" cy="11.507" rx="0.635" ry="0.635" style="fill:#fff;" />
   <ellipse cx="143.946" cy="61.644" rx="0.414" ry="0.414" style="fill:#fff;" />
   <ellipse cx="24.15" cy="120.959" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="236.215" cy="151.879" rx="0.609" ry="0.609" style="fill:#fff;" />
   <ellipse cx="197.19" cy="139.722" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="295.771" cy="9.445" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="22.965" cy="119.347" rx="0.601" ry="0.601" style="fill:#fff;" />
   <ellipse cx="480.874" cy="130.102" rx="0.463" ry="0.463" style="fill:#fff;" />
   <ellipse cx="51.772" cy="66.416" rx="0.364" ry="0.364" style="fill:#fff;" />
   <ellipse cx="206.523" cy="134.123" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="146.59" cy="139.482" rx="0.311" ry="0.311" style="fill:#fff;" />
   <ellipse cx="330.454" cy="12.387" rx="0.405" ry="0.405" style="fill:#fff;" />
   <ellipse cx="486.122" cy="165.8" rx="0.527" ry="0.527" style="fill:#fff;" />
   <ellipse cx="174.436" cy="176.203" rx="0.426" ry="0.426" style="fill:#fff;" />
   <ellipse cx="278.345" cy="178.84" rx="0.499" ry="0.499" style="fill:#fff;" />
   <ellipse cx="448.432" cy="88.578" rx="0.55" ry="0.55" style="fill:#fff;" />
   <ellipse cx="153.364" cy="75.296" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="196.741" cy="104.956" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="300.85" cy="26.142" rx="0.494" ry="0.494" style="fill:#fff;" />
   <ellipse cx="435.046" cy="138.206" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="476.635" cy="101.56" rx="0.229" ry="0.229" style="fill:#fff;" />
   <ellipse cx="46.214" cy="143.737" rx="0.656" ry="0.656" style="fill:#fff;" />
   <ellipse cx="135.326" cy="188.024" rx="0.51" ry="0.51" style="fill:#fff;" />
   <ellipse cx="167.368" cy="3.585" rx="0.283" ry="0.283" style="fill:#fff;" />
   <ellipse cx="157.979" cy="216.512" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="270.102" cy="220.504" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="351.148" cy="224.709" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="36.462" cy="222.527" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="257.538" cy="245.184" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="303.552" cy="234.169" rx="0.9" ry="0.9" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="455.338" cy="247.409" rx="0.583" ry="0.583" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="173.78" cy="240.5" rx="0.46" ry="0.46" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="4.183" cy="247.698" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="298.587" cy="227.388" rx="0.256" ry="0.256" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="67.356" cy="230.723" rx="0.595" ry="0.595" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="234.505" cy="217.01" rx="0.401" ry="0.401" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="356.404" cy="244.557" rx="0.647" ry="0.647" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="150.054" cy="212.753" rx="0.457" ry="0.457" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="263.452" cy="240.525" rx="0.327" ry="0.327" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="126.618" cy="240.978" rx="0.451" ry="0.451" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="307.015" cy="234.816" rx="0.28" ry="0.28" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="33.515" cy="224.525" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="206.557" cy="243.293" rx="0.439" ry="0.439" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="490.24" cy="233.666" rx="0.463" ry="0.463" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="215.888" cy="237.698" rx="0.346" ry="0.346" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="155.956" cy="243.059" rx="0.311" ry="0.311" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="444.41" cy="241.773" rx="0.419" ry="0.419" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="55.584" cy="247.301" rx="0.656" ry="0.656" style="fill:#fff;" />
  </g>
  <g>
   <ellipse cx="162.613" cy="957.398" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="274.732" cy="961.39" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="102.217" cy="805.766" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="495.989" cy="775.739" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="355.777" cy="965.596" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="138.835" cy="1000.34" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="41.096" cy="963.415" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="262.171" cy="986.07" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="390.893" cy="920.347" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="308.182" cy="975.056" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="223.448" cy="792.641" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="221.359" cy="802.673" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="122.737" cy="809.994" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="265.413" cy="862.044" rx="0.554" ry="0.554" style="fill:#fff;" />
   <ellipse cx="420.955" cy="772.049" rx="0.485" ry="0.485" style="fill:#fff;" />
   <ellipse cx="362.438" cy="995.674" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="107.581" cy="792.353" rx="0.354" ry="0.354" style="fill:#fff;" />
   <ellipse cx="459.967" cy="988.296" rx="0.583" ry="0.583" style="fill:#fff;" />
   <ellipse cx="482.585" cy="797.336" rx="0.361" ry="0.361" style="fill:#fff;" />
   <ellipse cx="96.111" cy="893.638" rx="0.662" ry="0.662" style="fill:#fff;" />
   <ellipse cx="178.414" cy="981.387" rx="0.46" ry="0.46" style="fill:#fff;" />
   <ellipse cx="486.956" cy="797.113" rx="0.304" ry="0.304" style="fill:#fff;" />
   <ellipse cx="177.592" cy="994.406" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="8.812" cy="988.578" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="303.221" cy="968.266" rx="0.256" ry="0.256" style="fill:#fff;" />
   <ellipse cx="477.844" cy="851.507" rx="0.289" ry="0.289" style="fill:#fff;" />
   <ellipse cx="74.031" cy="826.844" rx="0.638" ry="0.638" style="fill:#fff;" />
   <ellipse cx="79.637" cy="993.419" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="315.987" cy="940.832" rx="0.245" ry="0.245" style="fill:#fff;" />
   <ellipse cx="482.585" cy="820.156" rx="0.641" ry="0.641" style="fill:#fff;" />
   <ellipse cx="333.774" cy="795.959" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="249.417" cy="904.835" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="72.006" cy="971.609" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="445.997" cy="907.879" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="16.847" cy="794.616" rx="0.606" ry="0.606" style="fill:#fff;" />
   <ellipse cx="383.16" cy="845.332" rx="0.26" ry="0.26" style="fill:#fff;" />
   <ellipse cx="204.01" cy="904.699" rx="0.433" ry="0.433" style="fill:#fff;" />
   <ellipse cx="471.967" cy="822.589" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="500.995" cy="889.725" rx="0.636" ry="0.636" style="fill:#fff;" />
   <ellipse cx="58.083" cy="945.986" rx="0.624" ry="0.624" style="fill:#fff;" />
   <ellipse cx="256.88" cy="886.578" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="217.878" cy="917.788" rx="0.438" ry="0.438" style="fill:#fff;" />
   <ellipse cx="69.067" cy="788.8" rx="0.408" ry="0.408" style="fill:#fff;" />
   <ellipse cx="298.826" cy="831.167" rx="0.49" ry="0.49" style="fill:#fff;" />
   <ellipse cx="417.862" cy="851.534" rx="0.453" ry="0.453" style="fill:#fff;" />
   <ellipse cx="56.736" cy="870.909" rx="0.542" ry="0.542" style="fill:#fff;" />
   <ellipse cx="239.091" cy="937.282" rx="0.415" ry="0.415" style="fill:#fff;" />
   <ellipse cx="346.166" cy="780.486" rx="0.489" ry="0.489" style="fill:#fff;" />
   <ellipse cx="483.613" cy="868.252" rx="0.456" ry="0.456" style="fill:#fff;" />
   <ellipse cx="289.104" cy="881.573" rx="0.412" ry="0.412" style="fill:#fff;" />
   <ellipse cx="123.432" cy="826.55" rx="0.263" ry="0.263" style="fill:#fff;" />
   <ellipse cx="239.138" cy="957.895" rx="0.401" ry="0.401" style="fill:#fff;" />
   <ellipse cx="435.511" cy="863.229" rx="0.41" ry="0.41" style="fill:#fff;" />
   <ellipse cx="262.641" cy="997.147" rx="0.56" ry="0.56" style="fill:#fff;" />
   <ellipse cx="356.734" cy="827.327" rx="0.423" ry="0.423" style="fill:#fff;" />
   <ellipse cx="177.415" cy="896.157" rx="0.584" ry="0.584" style="fill:#fff;" />
   <ellipse cx="6.429" cy="846.499" rx="0.292" ry="0.292" style="fill:#fff;" />
   <ellipse cx="377.455" cy="773.791" rx="0.489" ry="0.489" style="fill:#fff;" />
   <ellipse cx="361.039" cy="985.445" rx="0.647" ry="0.647" style="fill:#fff;" />
   <ellipse cx="102.122" cy="808.808" rx="0.652" ry="0.652" style="fill:#fff;" />
   <ellipse cx="154.684" cy="953.644" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="444.158" cy="898.915" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="231.985" cy="766.983" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="313.755" cy="785.32" rx="0.452" ry="0.452" style="fill:#fff;" />
   <ellipse cx="401.877" cy="832.617" rx="0.253" ry="0.253" style="fill:#fff;" />
   <ellipse cx="91.573" cy="852.328" rx="0.379" ry="0.379" style="fill:#fff;" />
   <ellipse cx="419.707" cy="840.134" rx="0.353" ry="0.353" style="fill:#fff;" />
   <ellipse cx="393.784" cy="802.772" rx="0.315" ry="0.315" style="fill:#fff;" />
   <ellipse cx="59.14" cy="849.823" rx="0.535" ry="0.535" style="fill:#fff;" />
   <ellipse cx="9.876" cy="874.385" rx="0.282" ry="0.282" style="fill:#fff;" />
   <ellipse cx="341.928" cy="885.59" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="473.26" cy="837.77" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="268.081" cy="981.413" rx="0.327" ry="0.327" style="fill:#fff;" />
   <ellipse cx="445.266" cy="890.165" rx="0.551" ry="0.551" style="fill:#fff;" />
   <ellipse cx="205.529" cy="926.3" rx="0.407" ry="0.407" style="fill:#fff;" />
   <ellipse cx="259.58" cy="927.083" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="81.127" cy="843.216" rx="0.356" ry="0.356" style="fill:#fff;" />
   <ellipse cx="376.82" cy="826.124" rx="0.575" ry="0.575" style="fill:#fff;" />
   <ellipse cx="131.251" cy="981.863" rx="0.451" ry="0.451" style="fill:#fff;" />
   <ellipse cx="394.076" cy="891.948" rx="0.247" ry="0.247" style="fill:#fff;" />
   <ellipse cx="311.645" cy="975.709" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="176.219" cy="855.96" rx="0.635" ry="0.635" style="fill:#fff;" />
   <ellipse cx="157.946" cy="906.097" rx="0.414" ry="0.414" style="fill:#fff;" />
   <ellipse cx="38.15" cy="965.412" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="250.215" cy="996.332" rx="0.609" ry="0.609" style="fill:#fff;" />
   <ellipse cx="340.126" cy="784.093" rx="0.429" ry="0.429" style="fill:#fff;" />
   <ellipse cx="157.473" cy="815.252" rx="0.38" ry="0.38" style="fill:#fff;" />
   <ellipse cx="211.19" cy="984.175" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="309.771" cy="853.898" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="36.965" cy="963.8" rx="0.601" ry="0.601" style="fill:#fff;" />
   <ellipse cx="494.874" cy="974.555" rx="0.463" ry="0.463" style="fill:#fff;" />
   <ellipse cx="65.772" cy="910.869" rx="0.364" ry="0.364" style="fill:#fff;" />
   <ellipse cx="220.523" cy="978.576" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="160.59" cy="983.935" rx="0.311" ry="0.311" style="fill:#fff;" />
   <ellipse cx="344.454" cy="856.84" rx="0.405" ry="0.405" style="fill:#fff;" />
   <ellipse cx="462.432" cy="933.031" rx="0.55" ry="0.55" style="fill:#fff;" />
   <ellipse cx="167.364" cy="919.749" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="210.741" cy="949.409" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="392.496" cy="829.254" rx="0.521" ry="0.521" style="fill:#fff;" />
   <ellipse cx="314.85" cy="870.595" rx="0.494" ry="0.494" style="fill:#fff;" />
   <ellipse cx="449.046" cy="982.659" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="60.938" cy="802.808" rx="0.503" ry="0.503" style="fill:#fff;" />
   <ellipse cx="58.848" cy="780.584" rx="0.599" ry="0.599" style="fill:#fff;" />
   <ellipse cx="490.635" cy="946.013" rx="0.229" ry="0.229" style="fill:#fff;" />
   <ellipse cx="60.214" cy="988.19" rx="0.656" ry="0.656" style="fill:#fff;" />
   <ellipse cx="223.587" cy="835.536" rx="0.404" ry="0.404" style="fill:#fff;" />
   <ellipse cx="181.368" cy="848.038" rx="0.283" ry="0.283" style="fill:#fff;" />
   <ellipse cx="10.548" cy="775.034" rx="0.372" ry="0.372" style="fill:#fff;" />
  </g>
  <g>
   <ellipse cx="102.613" cy="574.806" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="214.732" cy="578.799" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="42.217" cy="423.174" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="435.989" cy="393.147" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="295.777" cy="583.004" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="55.111" cy="633.941" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="78.835" cy="617.745" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="202.171" cy="603.478" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="38.866" cy="621.013" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="330.893" cy="537.755" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="248.182" cy="592.464" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="163.448" cy="410.049" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="161.359" cy="420.081" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="62.737" cy="427.402" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="375.037" cy="648.446" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="205.413" cy="479.452" rx="0.554" ry="0.554" style="fill:#fff;" />
   <ellipse cx="360.955" cy="389.457" rx="0.485" ry="0.485" style="fill:#fff;" />
   <ellipse cx="336.513" cy="648.539" rx="0.467" ry="0.467" style="fill:#fff;" />
   <ellipse cx="302.438" cy="613.082" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="47.581" cy="409.761" rx="0.354" ry="0.354" style="fill:#fff;" />
   <ellipse cx="399.967" cy="605.704" rx="0.583" ry="0.583" style="fill:#fff;" />
   <ellipse cx="422.585" cy="414.744" rx="0.361" ry="0.361" style="fill:#fff;" />
   <ellipse cx="36.111" cy="511.046" rx="0.662" ry="0.662" style="fill:#fff;" />
   <ellipse cx="263.268" cy="629.994" rx="0.491" ry="0.491" style="fill:#fff;" />
   <ellipse cx="384.642" cy="646.054" rx="0.576" ry="0.576" style="fill:#fff;" />
   <ellipse cx="465.774" cy="590.966" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="92.193" cy="650.425" rx="0.378" ry="0.378" style="fill:#fff;" />
   <ellipse cx="118.414" cy="598.795" rx="0.46" ry="0.46" style="fill:#fff;" />
   <ellipse cx="426.956" cy="414.521" rx="0.304" ry="0.304" style="fill:#fff;" />
   <ellipse cx="117.592" cy="611.814" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="493.368" cy="550.381" rx="0.251" ry="0.251" style="fill:#fff;" />
   <ellipse cx="481.892" cy="647.633" rx="0.67" ry="0.67" style="fill:#fff;" />
   <ellipse cx="243.221" cy="585.674" rx="0.256" ry="0.256" style="fill:#fff;" />
   <ellipse cx="417.844" cy="468.915" rx="0.289" ry="0.289" style="fill:#fff;" />
   <ellipse cx="14.031" cy="444.252" rx="0.638" ry="0.638" style="fill:#fff;" />
   <ellipse cx="19.637" cy="610.827" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="255.987" cy="558.24" rx="0.245" ry="0.245" style="fill:#fff;" />
   <ellipse cx="489.198" cy="448.755" rx="0.363" ry="0.363" style="fill:#fff;" />
   <ellipse cx="422.585" cy="437.564" rx="0.641" ry="0.641" style="fill:#fff;" />
   <ellipse cx="273.774" cy="413.367" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="456.142" cy="470.414" rx="0.592" ry="0.592" style="fill:#fff;" />
   <ellipse cx="189.417" cy="522.243" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="12.006" cy="589.017" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="385.997" cy="525.287" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="323.16" cy="462.74" rx="0.26" ry="0.26" style="fill:#fff;" />
   <ellipse cx="144.01" cy="522.107" rx="0.433" ry="0.433" style="fill:#fff;" />
   <ellipse cx="411.967" cy="439.997" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="440.995" cy="507.133" rx="0.636" ry="0.636" style="fill:#fff;" />
   <ellipse cx="188.72" cy="635.117" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="196.88" cy="503.987" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="473.763" cy="605.34" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="491.778" cy="429.282" rx="0.632" ry="0.632" style="fill:#fff;" />
   <ellipse cx="157.878" cy="535.196" rx="0.438" ry="0.438" style="fill:#fff;" />
   <ellipse cx="9.067" cy="406.208" rx="0.408" ry="0.408" style="fill:#fff;" />
   <ellipse cx="238.826" cy="448.575" rx="0.49" ry="0.49" style="fill:#fff;" />
   <ellipse cx="357.862" cy="468.942" rx="0.453" ry="0.453" style="fill:#fff;" />
   <ellipse cx="431.316" cy="637.914" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="179.091" cy="554.69" rx="0.415" ry="0.415" style="fill:#fff;" />
   <ellipse cx="286.166" cy="397.894" rx="0.489" ry="0.489" style="fill:#fff;" />
   <ellipse cx="423.613" cy="485.66" rx="0.456" ry="0.456" style="fill:#fff;" />
   <ellipse cx="229.104" cy="498.981" rx="0.412" ry="0.412" style="fill:#fff;" />
   <ellipse cx="476.667" cy="614.987" rx="0.565" ry="0.565" style="fill:#fff;" />
   <ellipse cx="63.432" cy="443.958" rx="0.263" ry="0.263" style="fill:#fff;" />
   <ellipse cx="179.138" cy="575.303" rx="0.401" ry="0.401" style="fill:#fff;" />
   <ellipse cx="375.511" cy="480.637" rx="0.41" ry="0.41" style="fill:#fff;" />
   <ellipse cx="202.641" cy="614.555" rx="0.56" ry="0.56" style="fill:#fff;" />
   <ellipse cx="296.734" cy="444.735" rx="0.423" ry="0.423" style="fill:#fff;" />
   <ellipse cx="117.415" cy="513.565" rx="0.584" ry="0.584" style="fill:#fff;" />
   <ellipse cx="317.455" cy="391.199" rx="0.489" ry="0.489" style="fill:#fff;" />
   <ellipse cx="301.039" cy="602.853" rx="0.647" ry="0.647" style="fill:#fff;" />
   <ellipse cx="107.86" cy="637.079" rx="0.602" ry="0.602" style="fill:#fff;" />
   <ellipse cx="42.122" cy="426.216" rx="0.652" ry="0.652" style="fill:#fff;" />
   <ellipse cx="94.684" cy="571.052" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="384.158" cy="516.323" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="451.224" cy="487.325" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="171.985" cy="384.391" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="253.755" cy="402.728" rx="0.452" ry="0.452" style="fill:#fff;" />
   <ellipse cx="341.877" cy="450.025" rx="0.253" ry="0.253" style="fill:#fff;" />
   <ellipse cx="31.573" cy="469.736" rx="0.379" ry="0.379" style="fill:#fff;" />
   <ellipse cx="359.707" cy="457.542" rx="0.353" ry="0.353" style="fill:#fff;" />
   <ellipse cx="338.805" cy="635.315" rx="0.522" ry="0.522" style="fill:#fff;" />
   <ellipse cx="495.693" cy="507.402" rx="0.545" ry="0.545" style="fill:#fff;" />
   <ellipse cx="333.784" cy="420.181" rx="0.315" ry="0.315" style="fill:#fff;" />
   <ellipse cx="495.455" cy="640.253" rx="0.62" ry="0.62" style="fill:#fff;" />
   <ellipse cx="474.654" cy="633.039" rx="0.261" ry="0.261" style="fill:#fff;" />
   <ellipse cx="-0.86" cy="467.231" rx="0.535" ry="0.535" style="fill:#fff;" />
   <ellipse cx="281.928" cy="502.998" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="413.26" cy="455.178" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="208.081" cy="598.821" rx="0.327" ry="0.327" style="fill:#fff;" />
   <ellipse cx="457.725" cy="420.158" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="385.266" cy="507.573" rx="0.551" ry="0.551" style="fill:#fff;" />
   <ellipse cx="145.529" cy="543.708" rx="0.407" ry="0.407" style="fill:#fff;" />
   <ellipse cx="199.58" cy="544.491" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="21.127" cy="460.624" rx="0.356" ry="0.356" style="fill:#fff;" />
   <ellipse cx="316.82" cy="443.532" rx="0.575" ry="0.575" style="fill:#fff;" />
   <ellipse cx="252.263" cy="644.673" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="71.251" cy="599.271" rx="0.451" ry="0.451" style="fill:#fff;" />
   <ellipse cx="334.076" cy="509.356" rx="0.247" ry="0.247" style="fill:#fff;" />
   <ellipse cx="251.645" cy="593.117" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="116.219" cy="473.368" rx="0.635" ry="0.635" style="fill:#fff;" />
   <ellipse cx="97.946" cy="523.505" rx="0.414" ry="0.414" style="fill:#fff;" />
   <ellipse cx="190.215" cy="613.74" rx="0.609" ry="0.609" style="fill:#fff;" />
   <ellipse cx="464.343" cy="406.959" rx="0.505" ry="0.505" style="fill:#fff;" />
   <ellipse cx="280.126" cy="401.501" rx="0.429" ry="0.429" style="fill:#fff;" />
   <ellipse cx="97.473" cy="432.66" rx="0.38" ry="0.38" style="fill:#fff;" />
   <ellipse cx="151.19" cy="601.583" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="497.342" cy="500.683" rx="0.338" ry="0.337" style="fill:#fff;" />
   <ellipse cx="249.771" cy="471.306" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="434.874" cy="591.963" rx="0.463" ry="0.463" style="fill:#fff;" />
   <ellipse cx="488.913" cy="517.949" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="5.772" cy="528.277" rx="0.364" ry="0.364" style="fill:#fff;" />
   <ellipse cx="160.523" cy="595.984" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="100.59" cy="601.343" rx="0.311" ry="0.311" style="fill:#fff;" />
   <ellipse cx="284.454" cy="474.248" rx="0.405" ry="0.405" style="fill:#fff;" />
   <ellipse cx="440.122" cy="627.661" rx="0.527" ry="0.527" style="fill:#fff;" />
   <ellipse cx="128.436" cy="638.064" rx="0.426" ry="0.426" style="fill:#fff;" />
   <ellipse cx="232.345" cy="640.701" rx="0.499" ry="0.499" style="fill:#fff;" />
   <ellipse cx="402.432" cy="550.439" rx="0.55" ry="0.55" style="fill:#fff;" />
   <ellipse cx="107.364" cy="537.157" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="150.741" cy="566.817" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="332.496" cy="446.662" rx="0.521" ry="0.521" style="fill:#fff;" />
   <ellipse cx="254.85" cy="488.003" rx="0.494" ry="0.494" style="fill:#fff;" />
   <ellipse cx="462.748" cy="510.858" rx="0.502" ry="0.502" style="fill:#fff;" />
   <ellipse cx="389.046" cy="600.067" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="0.938" cy="420.216" rx="0.503" ry="0.503" style="fill:#fff;" />
   <ellipse cx="-1.152" cy="397.992" rx="0.599" ry="0.599" style="fill:#fff;" />
   <ellipse cx="430.635" cy="563.421" rx="0.229" ry="0.229" style="fill:#fff;" />
   <ellipse cx="0.214" cy="605.598" rx="0.656" ry="0.656" style="fill:#fff;" />
   <ellipse cx="89.326" cy="649.885" rx="0.51" ry="0.51" style="fill:#fff;" />
   <ellipse cx="163.587" cy="452.944" rx="0.404" ry="0.404" style="fill:#fff;" />
   <ellipse cx="121.368" cy="465.446" rx="0.283" ry="0.283" style="fill:#fff;" />
   <ellipse cx="111.979" cy="678.373" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="224.102" cy="682.365" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="305.148" cy="686.57" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="211.538" cy="707.045" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="257.552" cy="696.03" rx="0.9" ry="0.9" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="409.338" cy="709.27" rx="0.583" ry="0.583" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="475.144" cy="694.53" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="127.78" cy="702.361" rx="0.46" ry="0.46" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="252.587" cy="689.249" rx="0.256" ry="0.256" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="21.356" cy="692.584" rx="0.595" ry="0.595" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="483.129" cy="708.91" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="188.505" cy="678.871" rx="0.401" ry="0.401" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="310.404" cy="706.418" rx="0.647" ry="0.647" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="104.054" cy="674.614" rx="0.457" ry="0.457" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="217.452" cy="702.386" rx="0.327" ry="0.327" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="80.618" cy="702.839" rx="0.451" ry="0.451" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="261.015" cy="696.677" rx="0.28" ry="0.28" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="160.557" cy="705.154" rx="0.439" ry="0.439" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="444.24" cy="695.527" rx="0.463" ry="0.463" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="169.888" cy="699.559" rx="0.346" ry="0.346" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="109.956" cy="704.92" rx="0.311" ry="0.311" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="398.41" cy="703.634" rx="0.419" ry="0.419" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="9.584" cy="709.162" rx="0.656" ry="0.656" style="fill:#fff;" />
  </g>
  <g>
   <ellipse cx="111.613" cy="304.806" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="223.732" cy="308.799" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="51.217" cy="153.174" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="444.989" cy="123.147" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="304.777" cy="313.004" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="64.111" cy="363.941" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="87.835" cy="347.745" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="211.171" cy="333.478" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="47.866" cy="351.013" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="339.893" cy="267.755" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="257.182" cy="322.464" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="172.448" cy="140.049" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="170.359" cy="150.081" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="71.737" cy="157.402" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="384.037" cy="378.446" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="214.413" cy="209.452" rx="0.554" ry="0.554" style="fill:#fff;" />
   <ellipse cx="369.955" cy="119.457" rx="0.485" ry="0.485" style="fill:#fff;" />
   <ellipse cx="345.513" cy="378.539" rx="0.467" ry="0.467" style="fill:#fff;" />
   <ellipse cx="311.438" cy="343.082" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="56.581" cy="139.761" rx="0.354" ry="0.354" style="fill:#fff;" />
   <ellipse cx="408.967" cy="335.704" rx="0.583" ry="0.583" style="fill:#fff;" />
   <ellipse cx="431.585" cy="144.744" rx="0.361" ry="0.361" style="fill:#fff;" />
   <ellipse cx="45.111" cy="241.046" rx="0.662" ry="0.662" style="fill:#fff;" />
   <ellipse cx="272.268" cy="359.994" rx="0.491" ry="0.491" style="fill:#fff;" />
   <ellipse cx="393.642" cy="376.054" rx="0.576" ry="0.576" style="fill:#fff;" />
   <ellipse cx="474.774" cy="320.966" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="101.193" cy="380.425" rx="0.378" ry="0.378" style="fill:#fff;" />
   <ellipse cx="127.414" cy="328.795" rx="0.46" ry="0.46" style="fill:#fff;" />
   <ellipse cx="435.956" cy="144.521" rx="0.304" ry="0.304" style="fill:#fff;" />
   <ellipse cx="126.592" cy="341.814" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="490.892" cy="377.633" rx="0.67" ry="0.67" style="fill:#fff;" />
   <ellipse cx="252.221" cy="315.674" rx="0.256" ry="0.256" style="fill:#fff;" />
   <ellipse cx="426.844" cy="198.915" rx="0.289" ry="0.289" style="fill:#fff;" />
   <ellipse cx="23.031" cy="174.252" rx="0.638" ry="0.638" style="fill:#fff;" />
   <ellipse cx="28.637" cy="340.827" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="264.987" cy="288.24" rx="0.245" ry="0.245" style="fill:#fff;" />
   <ellipse cx="498.198" cy="178.755" rx="0.363" ry="0.363" style="fill:#fff;" />
   <ellipse cx="431.585" cy="167.564" rx="0.641" ry="0.641" style="fill:#fff;" />
   <ellipse cx="282.774" cy="143.367" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="465.142" cy="200.414" rx="0.592" ry="0.592" style="fill:#fff;" />
   <ellipse cx="198.417" cy="252.243" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="21.006" cy="319.017" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="394.997" cy="255.287" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="332.16" cy="192.74" rx="0.26" ry="0.26" style="fill:#fff;" />
   <ellipse cx="153.01" cy="252.107" rx="0.433" ry="0.433" style="fill:#fff;" />
   <ellipse cx="420.967" cy="169.997" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="449.995" cy="237.133" rx="0.636" ry="0.636" style="fill:#fff;" />
   <ellipse cx="197.72" cy="365.117" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="7.083" cy="293.394" rx="0.624" ry="0.624" style="fill:#fff;" />
   <ellipse cx="205.88" cy="233.987" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="482.763" cy="335.34" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="500.778" cy="159.282" rx="0.632" ry="0.632" style="fill:#fff;" />
   <ellipse cx="166.878" cy="265.196" rx="0.438" ry="0.438" style="fill:#fff;" />
   <ellipse cx="18.067" cy="136.208" rx="0.408" ry="0.408" style="fill:#fff;" />
   <ellipse cx="247.826" cy="178.575" rx="0.49" ry="0.49" style="fill:#fff;" />
   <ellipse cx="366.862" cy="198.942" rx="0.453" ry="0.453" style="fill:#fff;" />
   <ellipse cx="5.736" cy="218.317" rx="0.542" ry="0.542" style="fill:#fff;" />
   <ellipse cx="440.316" cy="367.914" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="188.091" cy="284.69" rx="0.415" ry="0.415" style="fill:#fff;" />
   <ellipse cx="295.166" cy="127.894" rx="0.489" ry="0.489" style="fill:#fff;" />
   <ellipse cx="432.613" cy="215.66" rx="0.456" ry="0.456" style="fill:#fff;" />
   <ellipse cx="238.104" cy="228.981" rx="0.412" ry="0.412" style="fill:#fff;" />
   <ellipse cx="485.667" cy="344.987" rx="0.565" ry="0.565" style="fill:#fff;" />
   <ellipse cx="72.432" cy="173.958" rx="0.263" ry="0.263" style="fill:#fff;" />
   <ellipse cx="188.138" cy="305.303" rx="0.401" ry="0.401" style="fill:#fff;" />
   <ellipse cx="384.511" cy="210.637" rx="0.41" ry="0.41" style="fill:#fff;" />
   <ellipse cx="211.641" cy="344.555" rx="0.56" ry="0.56" style="fill:#fff;" />
   <ellipse cx="305.734" cy="174.735" rx="0.423" ry="0.423" style="fill:#fff;" />
   <ellipse cx="126.415" cy="243.565" rx="0.584" ry="0.584" style="fill:#fff;" />
   <ellipse cx="326.455" cy="121.199" rx="0.489" ry="0.489" style="fill:#fff;" />
   <ellipse cx="310.039" cy="332.853" rx="0.647" ry="0.647" style="fill:#fff;" />
   <ellipse cx="116.86" cy="367.079" rx="0.602" ry="0.602" style="fill:#fff;" />
   <ellipse cx="51.122" cy="156.216" rx="0.652" ry="0.652" style="fill:#fff;" />
   <ellipse cx="103.684" cy="301.052" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="393.158" cy="246.323" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="460.224" cy="217.325" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="180.985" cy="114.391" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="262.755" cy="132.728" rx="0.452" ry="0.452" style="fill:#fff;" />
   <ellipse cx="350.877" cy="180.025" rx="0.253" ry="0.253" style="fill:#fff;" />
   <ellipse cx="40.573" cy="199.736" rx="0.379" ry="0.379" style="fill:#fff;" />
   <ellipse cx="368.707" cy="187.542" rx="0.353" ry="0.353" style="fill:#fff;" />
   <ellipse cx="347.805" cy="365.315" rx="0.522" ry="0.522" style="fill:#fff;" />
   <ellipse cx="5.492" cy="366.69" rx="0.667" ry="0.667" style="fill:#fff;" />
   <ellipse cx="342.784" cy="150.181" rx="0.315" ry="0.315" style="fill:#fff;" />
   <ellipse cx="483.654" cy="363.039" rx="0.261" ry="0.261" style="fill:#fff;" />
   <ellipse cx="8.14" cy="197.231" rx="0.535" ry="0.535" style="fill:#fff;" />
   <ellipse cx="290.928" cy="232.998" rx="0.593" ry="0.593" style="fill:#fff;" />
   <ellipse cx="422.26" cy="185.178" rx="0.607" ry="0.607" style="fill:#fff;" />
   <ellipse cx="217.081" cy="328.821" rx="0.327" ry="0.327" style="fill:#fff;" />
   <ellipse cx="466.725" cy="150.158" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="394.266" cy="237.573" rx="0.551" ry="0.551" style="fill:#fff;" />
   <ellipse cx="154.529" cy="273.708" rx="0.407" ry="0.407" style="fill:#fff;" />
   <ellipse cx="208.58" cy="274.491" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="30.127" cy="190.624" rx="0.356" ry="0.356" style="fill:#fff;" />
   <ellipse cx="325.82" cy="173.532" rx="0.575" ry="0.575" style="fill:#fff;" />
   <ellipse cx="261.263" cy="374.673" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="80.251" cy="329.271" rx="0.451" ry="0.451" style="fill:#fff;" />
   <ellipse cx="343.076" cy="239.356" rx="0.247" ry="0.247" style="fill:#fff;" />
   <ellipse cx="260.645" cy="323.117" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="125.219" cy="203.368" rx="0.635" ry="0.635" style="fill:#fff;" />
   <ellipse cx="106.946" cy="253.505" rx="0.414" ry="0.414" style="fill:#fff;" />
   <ellipse cx="199.215" cy="343.74" rx="0.609" ry="0.609" style="fill:#fff;" />
   <ellipse cx="473.343" cy="136.959" rx="0.505" ry="0.505" style="fill:#fff;" />
   <ellipse cx="289.126" cy="131.501" rx="0.429" ry="0.429" style="fill:#fff;" />
   <ellipse cx="106.473" cy="162.66" rx="0.38" ry="0.38" style="fill:#fff;" />
   <ellipse cx="160.19" cy="331.583" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="258.771" cy="201.306" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="443.874" cy="321.963" rx="0.463" ry="0.463" style="fill:#fff;" />
   <ellipse cx="497.913" cy="247.949" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="14.772" cy="258.277" rx="0.364" ry="0.364" style="fill:#fff;" />
   <ellipse cx="169.523" cy="325.984" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="109.59" cy="331.343" rx="0.311" ry="0.311" style="fill:#fff;" />
   <ellipse cx="293.454" cy="204.248" rx="0.405" ry="0.405" style="fill:#fff;" />
   <ellipse cx="449.122" cy="357.661" rx="0.527" ry="0.527" style="fill:#fff;" />
   <ellipse cx="137.436" cy="368.064" rx="0.426" ry="0.426" style="fill:#fff;" />
   <ellipse cx="241.345" cy="370.701" rx="0.499" ry="0.499" style="fill:#fff;" />
   <ellipse cx="411.432" cy="280.439" rx="0.55" ry="0.55" style="fill:#fff;" />
   <ellipse cx="116.364" cy="267.157" rx="0.385" ry="0.385" style="fill:#fff;" />
   <ellipse cx="159.741" cy="296.817" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="341.496" cy="176.662" rx="0.521" ry="0.521" style="fill:#fff;" />
   <ellipse cx="263.85" cy="218.003" rx="0.494" ry="0.494" style="fill:#fff;" />
   <ellipse cx="471.748" cy="240.858" rx="0.502" ry="0.502" style="fill:#fff;" />
   <ellipse cx="398.046" cy="330.067" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="9.938" cy="150.216" rx="0.503" ry="0.503" style="fill:#fff;" />
   <ellipse cx="7.848" cy="127.992" rx="0.599" ry="0.599" style="fill:#fff;" />
   <ellipse cx="439.635" cy="293.421" rx="0.229" ry="0.229" style="fill:#fff;" />
   <ellipse cx="9.214" cy="335.598" rx="0.656" ry="0.656" style="fill:#fff;" />
   <ellipse cx="98.326" cy="379.885" rx="0.51" ry="0.51" style="fill:#fff;" />
   <ellipse cx="172.587" cy="182.944" rx="0.404" ry="0.404" style="fill:#fff;" />
   <ellipse cx="130.368" cy="195.446" rx="0.283" ry="0.283" style="fill:#fff;" />
   <ellipse cx="120.979" cy="408.373" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="233.102" cy="412.365" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="314.148" cy="416.57" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="-0.538" cy="414.388" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="220.538" cy="437.045" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="266.552" cy="426.03" rx="0.9" ry="0.9" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="418.338" cy="439.27" rx="0.583" ry="0.583" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="484.144" cy="424.53" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="136.78" cy="432.361" rx="0.46" ry="0.46" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="261.587" cy="419.249" rx="0.256" ry="0.256" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="30.356" cy="422.584" rx="0.595" ry="0.595" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="492.129" cy="438.91" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="197.505" cy="408.871" rx="0.401" ry="0.401" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="319.404" cy="436.418" rx="0.647" ry="0.647" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="113.054" cy="404.614" rx="0.457" ry="0.457" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="226.452" cy="432.386" rx="0.327" ry="0.327" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="89.618" cy="432.839" rx="0.451" ry="0.451" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="270.015" cy="426.677" rx="0.28" ry="0.28" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="169.557" cy="435.154" rx="0.439" ry="0.439" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="453.24" cy="425.527" rx="0.463" ry="0.463" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="178.888" cy="429.559" rx="0.346" ry="0.346" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="118.956" cy="434.92" rx="0.311" ry="0.311" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="407.41" cy="433.634" rx="0.419" ry="0.419" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="18.584" cy="439.162" rx="0.656" ry="0.656" style="fill:#fff;" />
  </g>
  <g>
   <ellipse cx="96.014" cy="18.806" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="208.133" cy="22.799" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="289.179" cy="27.004" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="48.512" cy="77.941" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="72.236" cy="61.745" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="195.573" cy="47.478" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="32.268" cy="65.013" rx="0.45" ry="0.45" style="fill:#fff;" />
   <ellipse cx="241.584" cy="36.464" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="368.439" cy="92.446" rx="0.9" ry="0.9" style="fill:#fff;" />
   <ellipse cx="329.914" cy="92.539" rx="0.467" ry="0.467" style="fill:#fff;" />
   <ellipse cx="295.839" cy="57.082" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="393.369" cy="49.704" rx="0.583" ry="0.583" style="fill:#fff;" />
   <ellipse cx="256.67" cy="73.994" rx="0.491" ry="0.491" style="fill:#fff;" />
   <ellipse cx="378.044" cy="90.054" rx="0.576" ry="0.576" style="fill:#fff;" />
   <ellipse cx="459.175" cy="34.966" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="85.595" cy="94.425" rx="0.378" ry="0.378" style="fill:#fff;" />
   <ellipse cx="111.816" cy="42.795" rx="0.46" ry="0.46" style="fill:#fff;" />
   <ellipse cx="110.994" cy="55.814" rx="0.648" ry="0.648" style="fill:#fff;" />
   <ellipse cx="475.294" cy="91.633" rx="0.67" ry="0.67" style="fill:#fff;" />
   <ellipse cx="236.622" cy="29.674" rx="0.256" ry="0.256" style="fill:#fff;" />
   <ellipse cx="13.039" cy="54.827" rx="0.626" ry="0.626" style="fill:#fff;" />
   <ellipse cx="249.388" cy="2.24" rx="0.245" ry="0.245" style="fill:#fff;" />
   <ellipse cx="5.408" cy="33.017" rx="0.595" ry="0.595" style="fill:#fff;" />
   <ellipse cx="182.121" cy="79.117" rx="0.25" ry="0.25" style="fill:#fff;" />
   <ellipse cx="467.164" cy="49.34" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="424.718" cy="81.914" rx="0.572" ry="0.572" style="fill:#fff;" />
   <ellipse cx="172.492" cy="-1.31" rx="0.415" ry="0.415" style="fill:#fff;" />
   <ellipse cx="470.068" cy="58.987" rx="0.565" ry="0.565" style="fill:#fff;" />
   <ellipse cx="172.54" cy="19.303" rx="0.401" ry="0.401" style="fill:#fff;" />
   <ellipse cx="196.043" cy="58.555" rx="0.56" ry="0.56" style="fill:#fff;" />
   <ellipse cx="294.441" cy="46.853" rx="0.647" ry="0.647" style="fill:#fff;" />
   <ellipse cx="101.262" cy="81.079" rx="0.602" ry="0.602" style="fill:#fff;" />
   <ellipse cx="88.085" cy="15.052" rx="0.457" ry="0.457" style="fill:#fff;" />
   <ellipse cx="332.206" cy="79.315" rx="0.522" ry="0.522" style="fill:#fff;" />
   <ellipse cx="488.856" cy="84.253" rx="0.62" ry="0.62" style="fill:#fff;" />
   <ellipse cx="468.056" cy="77.039" rx="0.261" ry="0.261" style="fill:#fff;" />
   <ellipse cx="201.483" cy="42.821" rx="0.327" ry="0.327" style="fill:#fff;" />
   <ellipse cx="245.665" cy="88.673" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="64.653" cy="43.271" rx="0.451" ry="0.451" style="fill:#fff;" />
   <ellipse cx="245.046" cy="37.117" rx="0.28" ry="0.28" style="fill:#fff;" />
   <ellipse cx="183.617" cy="57.74" rx="0.609" ry="0.609" style="fill:#fff;" />
   <ellipse cx="144.592" cy="45.583" rx="0.439" ry="0.439" style="fill:#fff;" />
   <ellipse cx="428.276" cy="35.963" rx="0.463" ry="0.463" style="fill:#fff;" />
   <ellipse cx="153.925" cy="39.984" rx="0.346" ry="0.346" style="fill:#fff;" />
   <ellipse cx="93.991" cy="45.343" rx="0.311" ry="0.311" style="fill:#fff;" />
   <ellipse cx="433.523" cy="71.661" rx="0.527" ry="0.527" style="fill:#fff;" />
   <ellipse cx="121.838" cy="82.064" rx="0.426" ry="0.426" style="fill:#fff;" />
   <ellipse cx="225.747" cy="84.701" rx="0.499" ry="0.499" style="fill:#fff;" />
   <ellipse cx="144.143" cy="10.817" rx="0.531" ry="0.531" style="fill:#fff;" />
   <ellipse cx="382.447" cy="44.067" rx="0.419" ry="0.419" style="fill:#fff;" />
   <ellipse cx="424.037" cy="7.421" rx="0.229" ry="0.229" style="fill:#fff;" />
   <ellipse cx="82.728" cy="93.885" rx="0.51" ry="0.51" style="fill:#fff;" />
   <ellipse cx="105.38" cy="122.373" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="217.504" cy="126.365" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="298.549" cy="130.57" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="204.939" cy="151.045" rx="0.45" ry="0.45" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="250.954" cy="140.03" rx="0.9" ry="0.9" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="402.739" cy="153.27" rx="0.583" ry="0.583" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="468.546" cy="138.53" rx="0.655" ry="0.655" style="fill:#fff;" />
   <ellipse cx="121.182" cy="146.361" rx="0.46" ry="0.46" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="245.988" cy="133.249" rx="0.256" ry="0.256" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="14.758" cy="136.584" rx="0.595" ry="0.595" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="476.531" cy="152.91" rx="0.258" ry="0.258" style="fill:#fff;" />
   <ellipse cx="181.906" cy="122.871" rx="0.401" ry="0.401" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="303.805" cy="150.418" rx="0.647" ry="0.647" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="97.456" cy="118.614" rx="0.457" ry="0.457" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="210.853" cy="146.386" rx="0.327" ry="0.327" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="74.019" cy="146.839" rx="0.451" ry="0.451" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="254.417" cy="140.677" rx="0.28" ry="0.28" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="153.958" cy="149.154" rx="0.439" ry="0.439" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="437.642" cy="139.527" rx="0.463" ry="0.463" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="163.289" cy="143.559" rx="0.346" ry="0.346" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="103.357" cy="148.92" rx="0.311" ry="0.311" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="391.811" cy="147.634" rx="0.419" ry="0.419" style="fill:#fff;fill-opacity:0.68;" />
   <ellipse cx="2.986" cy="153.162" rx="0.656" ry="0.656" style="fill:#fff;" />
  </g>
  <path
   d="M42.542,32.719l-7.581,20.947l14.575,0l-6.994,-20.947Zm-31.312,4.028l0,-15.747l44.385,0l17.688,52.881l-19.995,-0l-3.332,-9.522l-15.711,0l-3.332,9.522l-18.97,-0l12.195,-37.134l-12.928,0Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M72.571,73.881l-0,-52.881l17.212,0l15.747,19.775l-0,-19.775l17.212,-0l-0,52.881l-17.212,-0l-15.747,-19.776l-0,19.776l-17.212,-0Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M124.939,73.881l-0,-52.881l17.212,0l15.747,19.775l-0,-19.775l17.212,-0l-0,52.881l-17.212,-0l-15.747,-19.776l-0,19.776l-17.212,-0Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M172.18,73.881l17.395,-52.881l26.258,0l17.688,52.881l-19.996,-0l-3.332,-9.522l-15.711,0l-3.332,9.522l-18.97,-0Zm30.579,-41.162l-7.581,20.947l14.575,0l-6.994,-20.947Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M302.222,51.469l-5.567,22.412l-17.212,-0l-12.158,-37.134l-10.986,0l-0,-15.747l24.243,0l7.251,22.852l6.299,-22.852l15.82,-0l7.361,22.852l4.907,-22.852l17.029,-0l-13.074,52.881l-17.212,-0l-6.701,-22.412Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M328.369,73.881l17.395,-52.881l26.257,0l17.688,52.881l-19.995,-0l-3.332,-9.522l-15.711,0l-3.332,9.522l-18.97,-0Zm30.579,-41.162l-7.581,20.947l14.575,0l-6.994,-20.947Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M388.977,73.881l0,-52.881l34.424,0c4.248,0.391 7.739,1.514 10.474,3.369c2.734,1.856 4.736,4.346 6.005,7.471c0.977,4.687 1.026,8.301 0.147,10.84c-0.879,2.539 -2.417,4.663 -4.614,6.372c-2.198,1.709 -5.347,3.052 -9.449,4.028l3.955,5.054l15.821,-0l-0,15.747l-20.874,-0l-16.773,-17.468l0,17.468l-19.116,-0Zm19.116,-39.697l0,9.741l13.33,-0c0.708,-0 1.477,-0.263 2.307,-0.788c0.831,-0.524 1.27,-1.849 1.319,-3.973c-0.122,-2.026 -0.617,-3.363 -1.483,-4.01c-0.867,-0.647 -1.593,-0.97 -2.179,-0.97l-13.294,-0Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M487.341,36.747l-12.89,0c-6.275,-0.195 -7.202,1.538 -2.784,5.2c7.911,6.934 11.792,13.672 11.646,20.215c-0.146,6.543 -4.028,10.449 -11.646,11.719l-28.125,-0l0,-15.747l11.133,-0c6.909,0.195 7.788,-1.734 2.637,-5.786c-8.496,-7.813 -12.109,-14.991 -10.84,-21.534c1.27,-6.543 5.274,-9.814 12.012,-9.814l28.857,0l0,15.747Z"
   style="fill:#ffd900;fill-rule:nonzero;" />
  <path
   d="M106.486,116.054l-0,-21.989l4.614,0c2.212,0 3.959,0.218 5.241,0.655c1.376,0.427 2.625,1.154 3.745,2.179c2.269,2.07 3.404,4.79 3.404,8.16c-0,3.38 -1.182,6.115 -3.546,8.204c-1.187,1.044 -2.431,1.77 -3.731,2.179c-1.216,0.408 -2.939,0.612 -5.17,0.612l-4.557,-0Zm3.318,-3.119l1.495,0c1.491,0 2.73,-0.157 3.717,-0.47c0.988,-0.332 1.88,-0.859 2.678,-1.581c1.633,-1.49 2.449,-3.432 2.449,-5.825c0,-2.411 -0.807,-4.367 -2.421,-5.867c-1.453,-1.339 -3.593,-2.008 -6.423,-2.008l-1.495,-0l-0,15.751Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M130.255,102.183l-0,13.871l-3.205,-0l0,-13.871l3.205,-0Zm-3.689,-5.768c0,-0.56 0.204,-1.045 0.613,-1.453c0.408,-0.408 0.897,-0.612 1.466,-0.612c0.58,-0 1.073,0.204 1.482,0.612c0.408,0.399 0.612,0.888 0.612,1.467c-0,0.579 -0.204,1.073 -0.612,1.481c-0.399,0.408 -0.888,0.613 -1.467,0.613c-0.58,-0 -1.073,-0.205 -1.481,-0.613c-0.409,-0.408 -0.613,-0.906 -0.613,-1.495Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M146.946,109.873l-9.941,0c0.086,1.139 0.456,2.046 1.111,2.72c0.655,0.665 1.495,0.997 2.521,0.997c0.797,0 1.457,-0.19 1.979,-0.569c0.513,-0.38 1.097,-1.083 1.752,-2.108l2.706,1.509c-0.418,0.712 -0.859,1.322 -1.325,1.83c-0.465,0.508 -0.963,0.926 -1.495,1.254c-0.532,0.327 -1.106,0.567 -1.723,0.719c-0.617,0.152 -1.287,0.228 -2.008,0.228c-2.07,-0 -3.731,-0.665 -4.985,-1.994c-1.253,-1.339 -1.88,-3.114 -1.88,-5.326c0,-2.194 0.608,-3.969 1.823,-5.327c1.225,-1.338 2.849,-2.008 4.871,-2.008c2.041,0 3.655,0.651 4.842,1.951c1.177,1.292 1.766,3.081 1.766,5.369l-0.014,0.755Zm-3.29,-2.62c-0.446,-1.709 -1.524,-2.564 -3.233,-2.564c-0.389,0 -0.755,0.06 -1.096,0.178c-0.342,0.119 -0.653,0.29 -0.933,0.513c-0.28,0.223 -0.52,0.491 -0.719,0.805c-0.2,0.313 -0.352,0.669 -0.456,1.068l6.437,-0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M167.511,106.683l6.807,9.371l-4.059,-0l-6.28,-9.001l-0.599,0l0,9.001l-3.318,-0l0,-21.989l3.888,0c2.905,0 5.004,0.546 6.295,1.638c1.424,1.215 2.136,2.82 2.136,4.813c0,1.558 -0.446,2.896 -1.339,4.017c-0.892,1.12 -2.069,1.837 -3.531,2.15Zm-4.131,-2.521l1.054,0c3.143,0 4.714,-1.201 4.714,-3.603c0,-2.25 -1.528,-3.375 -4.585,-3.375l-1.183,-0l0,6.978Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M186.737,102.183l3.218,-0l0,13.871l-3.218,-0l-0,-1.453c-1.32,1.235 -2.74,1.852 -4.259,1.852c-1.917,-0 -3.503,-0.693 -4.756,-2.08c-1.244,-1.414 -1.866,-3.18 -1.866,-5.297c0,-2.08 0.622,-3.812 1.866,-5.199c1.243,-1.386 2.801,-2.079 4.671,-2.079c1.614,0 3.062,0.665 4.344,1.994l-0,-1.609Zm-7.605,6.893c-0,1.329 0.356,2.411 1.068,3.247c0.731,0.845 1.652,1.267 2.763,1.267c1.186,0 2.145,-0.408 2.876,-1.225c0.731,-0.845 1.097,-1.917 1.097,-3.218c-0,-1.301 -0.366,-2.374 -1.097,-3.219c-0.731,-0.826 -1.68,-1.239 -2.848,-1.239c-1.101,0 -2.022,0.418 -2.763,1.253c-0.731,0.845 -1.096,1.89 -1.096,3.134Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M204.795,102.781l-0,4.258c-0.731,-0.892 -1.386,-1.505 -1.965,-1.837c-0.57,-0.342 -1.239,-0.513 -2.009,-0.513c-1.205,0 -2.207,0.423 -3.004,1.268c-0.798,0.845 -1.197,1.903 -1.197,3.176c0,1.3 0.385,2.368 1.154,3.204c0.778,0.835 1.771,1.253 2.976,1.253c0.769,0 1.448,-0.166 2.037,-0.498c0.569,-0.323 1.239,-0.95 2.008,-1.88l-0,4.23c-1.301,0.674 -2.602,1.011 -3.902,1.011c-2.146,-0 -3.94,-0.693 -5.384,-2.08c-1.443,-1.395 -2.164,-3.128 -2.164,-5.198c-0,-2.069 0.731,-3.816 2.193,-5.241c1.462,-1.424 3.256,-2.136 5.383,-2.136c1.367,0 2.659,0.328 3.874,0.983Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M208.654,92l3.205,0l-0,11.336c1.139,-1.025 2.397,-1.538 3.774,-1.538c1.566,0 2.82,0.508 3.759,1.524c0.798,0.883 1.197,2.293 1.197,4.23l-0,8.502l-3.205,-0l0,-8.203c0,-1.111 -0.197,-1.916 -0.591,-2.414c-0.394,-0.499 -1.027,-0.748 -1.901,-0.748c-1.12,0 -1.908,0.347 -2.364,1.04c-0.446,0.702 -0.669,1.908 -0.669,3.617l-0,6.708l-3.205,-0l0,-24.054Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M237.28,109.873l-9.941,0c0.086,1.139 0.456,2.046 1.111,2.72c0.655,0.665 1.495,0.997 2.521,0.997c0.797,0 1.457,-0.19 1.979,-0.569c0.513,-0.38 1.097,-1.083 1.752,-2.108l2.706,1.509c-0.418,0.712 -0.859,1.322 -1.324,1.83c-0.466,0.508 -0.964,0.926 -1.496,1.254c-0.532,0.327 -1.106,0.567 -1.723,0.719c-0.617,0.152 -1.287,0.228 -2.008,0.228c-2.07,-0 -3.731,-0.665 -4.985,-1.994c-1.253,-1.339 -1.88,-3.114 -1.88,-5.326c0,-2.194 0.608,-3.969 1.823,-5.327c1.225,-1.338 2.849,-2.008 4.871,-2.008c2.041,0 3.655,0.651 4.842,1.951c1.177,1.292 1.766,3.081 1.766,5.369l-0.014,0.755Zm-3.29,-2.62c-0.446,-1.709 -1.524,-2.564 -3.233,-2.564c-0.389,0 -0.755,0.06 -1.096,0.178c-0.342,0.119 -0.653,0.29 -0.933,0.513c-0.28,0.223 -0.52,0.491 -0.719,0.805c-0.2,0.313 -0.352,0.669 -0.456,1.068l6.437,-0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M260.009,92l3.219,0l-0,24.054l-3.219,-0l0,-1.453c-1.262,1.235 -2.691,1.852 -4.286,1.852c-1.899,-0 -3.475,-0.693 -4.729,-2.08c-1.243,-1.414 -1.865,-3.18 -1.865,-5.297c-0,-2.07 0.622,-3.798 1.865,-5.184c1.235,-1.396 2.787,-2.094 4.657,-2.094c1.624,0 3.077,0.665 4.358,1.994l0,-11.792Zm-7.605,17.076c0,1.329 0.356,2.411 1.068,3.247c0.732,0.845 1.652,1.267 2.763,1.267c1.187,0 2.146,-0.408 2.877,-1.225c0.731,-0.845 1.097,-1.917 1.097,-3.218c-0,-1.301 -0.366,-2.374 -1.097,-3.219c-0.731,-0.826 -1.68,-1.239 -2.848,-1.239c-1.102,0 -2.023,0.418 -2.763,1.253c-0.731,0.845 -1.097,1.89 -1.097,3.134Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M279.905,109.873l-9.941,0c0.086,1.139 0.456,2.046 1.111,2.72c0.655,0.665 1.495,0.997 2.521,0.997c0.797,0 1.457,-0.19 1.979,-0.569c0.513,-0.38 1.097,-1.083 1.752,-2.108l2.706,1.509c-0.418,0.712 -0.859,1.322 -1.325,1.83c-0.465,0.508 -0.963,0.926 -1.495,1.254c-0.532,0.327 -1.106,0.567 -1.723,0.719c-0.617,0.152 -1.287,0.228 -2.008,0.228c-2.07,-0 -3.731,-0.665 -4.985,-1.994c-1.253,-1.339 -1.88,-3.114 -1.88,-5.326c0,-2.194 0.608,-3.969 1.823,-5.327c1.225,-1.338 2.849,-2.008 4.871,-2.008c2.041,0 3.655,0.651 4.842,1.951c1.177,1.292 1.766,3.081 1.766,5.369l-0.014,0.755Zm-3.29,-2.62c-0.446,-1.709 -1.524,-2.564 -3.233,-2.564c-0.389,0 -0.755,0.06 -1.096,0.178c-0.342,0.119 -0.653,0.29 -0.933,0.513c-0.28,0.223 -0.52,0.491 -0.719,0.805c-0.2,0.313 -0.352,0.669 -0.456,1.068l6.437,-0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M283.408,102.183l3.205,-0l-0,1.239c0.588,-0.617 1.11,-1.04 1.566,-1.268c0.465,-0.237 1.016,-0.356 1.652,-0.356c0.845,0 1.728,0.276 2.649,0.826l-1.467,2.934c-0.607,-0.437 -1.201,-0.655 -1.78,-0.655c-1.747,-0 -2.62,1.32 -2.62,3.959l-0,7.192l-3.205,-0l0,-13.871Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M316.363,97.341l-2.692,1.595c-0.503,-0.874 -0.982,-1.444 -1.438,-1.709c-0.475,-0.304 -1.087,-0.456 -1.837,-0.456c-0.921,-0 -1.685,0.261 -2.293,0.783c-0.608,0.513 -0.911,1.159 -0.911,1.937c-0,1.073 0.797,1.937 2.392,2.592l2.193,0.897c1.785,0.722 3.091,1.602 3.917,2.642c0.826,1.04 1.239,2.314 1.239,3.824c-0,2.022 -0.674,3.693 -2.023,5.013c-1.357,1.329 -3.043,1.994 -5.055,1.994c-1.909,-0 -3.485,-0.565 -4.728,-1.695c-1.225,-1.13 -1.99,-2.72 -2.293,-4.771l3.361,-0.74c0.152,1.291 0.417,2.183 0.797,2.677c0.684,0.949 1.681,1.424 2.991,1.424c1.035,0 1.894,-0.346 2.578,-1.04c0.683,-0.693 1.025,-1.571 1.025,-2.634c-0,-0.427 -0.059,-0.819 -0.178,-1.175c-0.119,-0.356 -0.304,-0.684 -0.555,-0.983c-0.252,-0.299 -0.577,-0.579 -0.976,-0.84c-0.399,-0.261 -0.873,-0.51 -1.424,-0.748l-2.122,-0.883c-3.01,-1.272 -4.515,-3.133 -4.515,-5.582c0,-1.652 0.632,-3.034 1.894,-4.145c1.263,-1.12 2.834,-1.68 4.714,-1.68c2.535,-0 4.515,1.234 5.939,3.703Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M331.117,102.781l0,4.258c-0.731,-0.892 -1.386,-1.505 -1.965,-1.837c-0.57,-0.342 -1.239,-0.513 -2.008,-0.513c-1.206,0 -2.208,0.423 -3.005,1.268c-0.798,0.845 -1.196,1.903 -1.196,3.176c-0,1.3 0.384,2.368 1.153,3.204c0.779,0.835 1.771,1.253 2.977,1.253c0.769,0 1.448,-0.166 2.036,-0.498c0.57,-0.323 1.239,-0.95 2.008,-1.88l0,4.23c-1.3,0.674 -2.601,1.011 -3.902,1.011c-2.146,-0 -3.94,-0.693 -5.383,-2.08c-1.443,-1.395 -2.165,-3.128 -2.165,-5.198c0,-2.069 0.731,-3.816 2.193,-5.241c1.462,-1.424 3.257,-2.136 5.384,-2.136c1.367,0 2.658,0.328 3.873,0.983Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M334.977,92l3.204,0l0,11.336c1.139,-1.025 2.397,-1.538 3.774,-1.538c1.567,0 2.82,0.508 3.76,1.524c0.797,0.883 1.196,2.293 1.196,4.23l0,8.502l-3.204,-0l-0,-8.203c-0,-1.111 -0.197,-1.916 -0.591,-2.414c-0.394,-0.499 -1.028,-0.748 -1.901,-0.748c-1.121,0 -1.909,0.347 -2.365,1.04c-0.446,0.702 -0.669,1.908 -0.669,3.617l0,6.708l-3.204,-0l-0,-24.054Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M354.174,102.183l0,7.961c0,2.297 0.907,3.446 2.72,3.446c1.814,0 2.721,-1.149 2.721,-3.446l-0,-7.961l3.204,-0l-0,8.032c-0,1.111 -0.138,2.07 -0.413,2.877c-0.266,0.721 -0.726,1.372 -1.381,1.951c-1.083,0.94 -2.46,1.41 -4.131,1.41c-1.661,-0 -3.033,-0.47 -4.115,-1.41c-0.665,-0.579 -1.135,-1.23 -1.41,-1.951c-0.266,-0.646 -0.399,-1.605 -0.399,-2.877l0,-8.032l3.204,-0Zm-2.278,-4.415c-0,-0.551 0.199,-1.021 0.598,-1.41c0.399,-0.399 0.878,-0.598 1.438,-0.598c0.56,-0 1.04,0.199 1.439,0.598c0.398,0.389 0.598,0.864 0.598,1.424c-0,0.57 -0.2,1.054 -0.598,1.453c-0.418,0.389 -0.898,0.584 -1.439,0.584c-0.569,-0 -1.054,-0.2 -1.452,-0.599c-0.39,-0.417 -0.584,-0.902 -0.584,-1.452Zm5.953,-0c-0,-0.551 0.199,-1.021 0.598,-1.41c0.408,-0.399 0.888,-0.598 1.438,-0.598c0.57,-0 1.049,0.199 1.439,0.598c0.398,0.389 0.598,0.864 0.598,1.424c-0,0.57 -0.2,1.054 -0.598,1.453c-0.418,0.389 -0.898,0.584 -1.439,0.584c-0.56,-0 -1.039,-0.2 -1.438,-0.599c-0.399,-0.398 -0.598,-0.883 -0.598,-1.452Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <rect x="366.864" y="92" width="3.204" height="24.054" style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M386.759,109.873l-9.941,0c0.086,1.139 0.456,2.046 1.111,2.72c0.655,0.665 1.496,0.997 2.521,0.997c0.798,0 1.457,-0.19 1.98,-0.569c0.512,-0.38 1.096,-1.083 1.751,-2.108l2.706,1.509c-0.418,0.712 -0.859,1.322 -1.324,1.83c-0.466,0.508 -0.964,0.926 -1.496,1.254c-0.531,0.327 -1.106,0.567 -1.723,0.719c-0.617,0.152 -1.286,0.228 -2.008,0.228c-2.07,-0 -3.731,-0.665 -4.984,-1.994c-1.254,-1.339 -1.88,-3.114 -1.88,-5.326c-0,-2.194 0.607,-3.969 1.823,-5.327c1.224,-1.338 2.848,-2.008 4.87,-2.008c2.041,0 3.655,0.651 4.842,1.951c1.178,1.292 1.766,3.081 1.766,5.369l-0.014,0.755Zm-3.29,-2.62c-0.446,-1.709 -1.524,-2.564 -3.233,-2.564c-0.389,0 -0.754,0.06 -1.096,0.178c-0.342,0.119 -0.653,0.29 -0.933,0.513c-0.28,0.223 -0.52,0.491 -0.719,0.805c-0.2,0.313 -0.352,0.669 -0.456,1.068l6.437,-0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M390.262,102.183l3.205,-0l-0,1.239c0.588,-0.617 1.111,-1.04 1.566,-1.268c0.466,-0.237 1.016,-0.356 1.652,-0.356c0.845,0 1.728,0.276 2.649,0.826l-1.467,2.934c-0.607,-0.437 -1.201,-0.655 -1.78,-0.655c-1.747,-0 -2.62,1.32 -2.62,3.959l-0,7.192l-3.205,-0l0,-13.871Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path d="M19.918,747.52l4.344,10.885l4.405,-10.885l2.594,0l-7.05,16.887l-6.887,-16.887l2.594,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M35.269,753.319l-0,9.908l-2.289,-0l-0,-9.908l2.289,-0Zm-2.635,-4.12c-0,-0.4 0.146,-0.746 0.437,-1.038c0.292,-0.291 0.641,-0.437 1.048,-0.437c0.414,-0 0.766,0.146 1.058,0.437c0.292,0.285 0.437,0.634 0.437,1.048c0,0.414 -0.145,0.766 -0.437,1.058c-0.285,0.292 -0.634,0.437 -1.048,0.437c-0.413,0 -0.766,-0.145 -1.058,-0.437c-0.291,-0.292 -0.437,-0.648 -0.437,-1.068Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M47.191,758.812l-7.101,-0c0.061,0.814 0.326,1.461 0.794,1.943c0.468,0.474 1.068,0.712 1.8,0.712c0.57,-0 1.041,-0.136 1.414,-0.407c0.367,-0.271 0.784,-0.773 1.252,-1.506l1.932,1.079c-0.298,0.508 -0.613,0.944 -0.946,1.307c-0.332,0.363 -0.688,0.661 -1.068,0.895c-0.38,0.234 -0.79,0.405 -1.231,0.514c-0.44,0.108 -0.919,0.163 -1.434,0.163c-1.478,-0 -2.665,-0.475 -3.56,-1.425c-0.896,-0.956 -1.343,-2.224 -1.343,-3.804c-0,-1.567 0.434,-2.835 1.302,-3.805c0.875,-0.956 2.034,-1.434 3.479,-1.434c1.458,-0 2.611,0.465 3.459,1.394c0.841,0.922 1.261,2.2 1.261,3.835l-0.01,0.539Zm-2.35,-1.872c-0.319,-1.221 -1.089,-1.831 -2.309,-1.831c-0.278,0 -0.539,0.042 -0.783,0.127c-0.245,0.085 -0.467,0.207 -0.667,0.366c-0.2,0.16 -0.371,0.351 -0.514,0.575c-0.142,0.224 -0.25,0.478 -0.325,0.763l4.598,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <rect x="49.693" y="746.045" width="2.289" height="17.181" style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M63.904,758.812l-7.1,-0c0.061,0.814 0.325,1.461 0.793,1.943c0.468,0.474 1.068,0.712 1.801,0.712c0.569,-0 1.041,-0.136 1.414,-0.407c0.366,-0.271 0.783,-0.773 1.251,-1.506l1.933,1.079c-0.299,0.508 -0.614,0.944 -0.946,1.307c-0.333,0.363 -0.689,0.661 -1.068,0.895c-0.38,0.234 -0.79,0.405 -1.231,0.514c-0.441,0.108 -0.919,0.163 -1.435,0.163c-1.478,-0 -2.665,-0.475 -3.56,-1.425c-0.895,-0.956 -1.343,-2.224 -1.343,-3.804c0,-1.567 0.434,-2.835 1.302,-3.805c0.875,-0.956 2.035,-1.434 3.479,-1.434c1.458,-0 2.611,0.465 3.459,1.394c0.841,0.922 1.261,2.2 1.261,3.835l-0.01,0.539Zm-2.35,-1.872c-0.318,-1.221 -1.088,-1.831 -2.309,-1.831c-0.278,0 -0.539,0.042 -0.783,0.127c-0.244,0.085 -0.466,0.207 -0.666,0.366c-0.2,0.16 -0.372,0.351 -0.514,0.575c-0.142,0.224 -0.251,0.478 -0.326,0.763l4.598,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M66.407,753.319l2.299,-0l-0,0.915c0.8,-0.793 1.702,-1.19 2.706,-1.19c1.152,-0 2.051,0.363 2.695,1.088c0.556,0.618 0.834,1.625 0.834,3.022l0,6.073l-2.299,-0l0,-5.534c0,-0.977 -0.135,-1.651 -0.406,-2.024c-0.265,-0.38 -0.746,-0.57 -1.445,-0.57c-0.759,-0 -1.299,0.251 -1.617,0.753c-0.312,0.495 -0.468,1.359 -0.468,2.594l-0,4.781l-2.299,-0l-0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M84.697,763.227l-0,-15.707l3.296,0c1.58,0 2.828,0.156 3.743,0.468c0.984,0.305 1.875,0.824 2.676,1.557c1.62,1.478 2.431,3.421 2.431,5.829c-0,2.414 -0.844,4.367 -2.533,5.859c-0.848,0.746 -1.736,1.265 -2.665,1.556c-0.868,0.292 -2.099,0.438 -3.693,0.438l-3.255,-0Zm2.37,-2.228l1.068,-0c1.065,-0 1.95,-0.112 2.655,-0.336c0.706,-0.237 1.343,-0.614 1.913,-1.129c1.166,-1.065 1.749,-2.452 1.749,-4.16c0,-1.723 -0.576,-3.12 -1.729,-4.192c-1.038,-0.956 -2.567,-1.434 -4.588,-1.434l-1.068,0l0,11.251Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M106.69,753.319l2.299,-0l-0,9.908l-2.299,-0l-0,-1.038c-0.943,0.882 -1.957,1.323 -3.042,1.323c-1.37,-0 -2.502,-0.496 -3.397,-1.486c-0.889,-1.01 -1.333,-2.272 -1.333,-3.784c0,-1.485 0.444,-2.723 1.333,-3.713c0.888,-0.99 2,-1.485 3.336,-1.485c1.153,-0 2.187,0.475 3.103,1.424l-0,-1.149Zm-5.432,4.923c-0,0.95 0.254,1.723 0.763,2.319c0.522,0.604 1.18,0.906 1.973,0.906c0.848,-0 1.533,-0.292 2.055,-0.875c0.522,-0.604 0.783,-1.37 0.783,-2.299c0,-0.929 -0.261,-1.695 -0.783,-2.299c-0.522,-0.59 -1.2,-0.885 -2.034,-0.885c-0.787,0 -1.445,0.298 -1.974,0.895c-0.522,0.604 -0.783,1.35 -0.783,2.238Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M111.878,753.319l2.299,-0l-0,0.915c0.8,-0.793 1.702,-1.19 2.706,-1.19c1.153,-0 2.051,0.363 2.695,1.088c0.557,0.618 0.835,1.625 0.835,3.022l-0,6.073l-2.299,-0l-0,-5.534c-0,-0.977 -0.136,-1.651 -0.407,-2.024c-0.265,-0.38 -0.746,-0.57 -1.445,-0.57c-0.759,-0 -1.298,0.251 -1.617,0.753c-0.312,0.495 -0.468,1.359 -0.468,2.594l-0,4.781l-2.299,-0l-0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M125.59,746.045l0,10.478l3.225,-3.204l3.072,-0l-4.303,4.16l4.619,5.748l-2.971,-0l-3.275,-4.181l-0.367,0.366l0,3.815l-2.288,-0l-0,-17.182l2.288,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M147.411,753.319l2.299,-0l-0,9.908l-2.299,-0l-0,-1.038c-0.943,0.882 -1.957,1.323 -3.042,1.323c-1.37,-0 -2.502,-0.496 -3.398,-1.486c-0.888,-1.01 -1.332,-2.272 -1.332,-3.784c-0,-1.485 0.444,-2.723 1.332,-3.713c0.889,-0.99 2.001,-1.485 3.337,-1.485c1.153,-0 2.187,0.475 3.103,1.424l-0,-1.149Zm-5.433,4.923c0,0.95 0.255,1.723 0.763,2.319c0.523,0.604 1.18,0.906 1.974,0.906c0.848,-0 1.532,-0.292 2.055,-0.875c0.522,-0.604 0.783,-1.37 0.783,-2.299c-0,-0.929 -0.261,-1.695 -0.783,-2.299c-0.523,-0.59 -1.201,-0.885 -2.035,-0.885c-0.787,0 -1.444,0.298 -1.973,0.895c-0.523,0.604 -0.784,1.35 -0.784,2.238Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M152.599,753.319l2.299,-0l-0,0.915c0.8,-0.793 1.702,-1.19 2.705,-1.19c1.153,-0 2.052,0.363 2.696,1.088c0.556,0.618 0.834,1.625 0.834,3.022l0,6.073l-2.299,-0l0,-5.534c0,-0.977 -0.135,-1.651 -0.407,-2.024c-0.264,-0.38 -0.746,-0.57 -1.444,-0.57c-0.76,-0 -1.299,0.251 -1.618,0.753c-0.312,0.495 -0.467,1.359 -0.467,2.594l-0,4.781l-2.299,-0l-0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M172.74,753.319l0,5.686c0,1.641 0.648,2.462 1.943,2.462c1.295,-0 1.943,-0.821 1.943,-2.462l0,-5.686l2.289,-0l-0,5.737c-0,0.793 -0.098,1.478 -0.295,2.055c-0.19,0.515 -0.519,0.98 -0.987,1.393c-0.773,0.672 -1.756,1.008 -2.95,1.008c-1.187,-0 -2.167,-0.336 -2.94,-1.008c-0.475,-0.413 -0.81,-0.878 -1.007,-1.393c-0.19,-0.461 -0.285,-1.146 -0.285,-2.055l0,-5.737l2.289,-0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M181.804,753.319l2.299,-0l-0,0.915c0.8,-0.793 1.702,-1.19 2.706,-1.19c1.153,-0 2.051,0.363 2.695,1.088c0.557,0.618 0.835,1.625 0.835,3.022l-0,6.073l-2.299,-0l-0,-5.534c-0,-0.977 -0.136,-1.651 -0.407,-2.024c-0.265,-0.38 -0.746,-0.57 -1.445,-0.57c-0.759,-0 -1.298,0.251 -1.617,0.753c-0.312,0.495 -0.468,1.359 -0.468,2.594l-0,4.781l-2.299,-0l-0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M198.985,755.007l-1.892,1.007c-0.298,-0.61 -0.668,-0.915 -1.109,-0.915c-0.21,-0 -0.39,0.069 -0.539,0.208c-0.149,0.139 -0.224,0.317 -0.224,0.534c0,0.38 0.441,0.757 1.323,1.13c1.214,0.522 2.031,1.003 2.451,1.444c0.421,0.441 0.631,1.034 0.631,1.78c0,0.956 -0.353,1.757 -1.058,2.401c-0.685,0.61 -1.512,0.916 -2.482,0.916c-1.661,-0 -2.838,-0.811 -3.53,-2.432l1.953,-0.905c0.272,0.475 0.478,0.776 0.621,0.905c0.278,0.258 0.61,0.387 0.997,0.387c0.773,-0 1.159,-0.353 1.159,-1.058c0,-0.407 -0.298,-0.787 -0.895,-1.139c-0.23,-0.116 -0.461,-0.228 -0.691,-0.336c-0.231,-0.109 -0.465,-0.221 -0.702,-0.336c-0.665,-0.325 -1.133,-0.651 -1.404,-0.976c-0.346,-0.414 -0.519,-0.946 -0.519,-1.597c0,-0.862 0.295,-1.574 0.885,-2.137c0.604,-0.563 1.336,-0.844 2.197,-0.844c1.268,-0 2.211,0.654 2.828,1.963Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M210.704,758.812l-7.1,-0c0.061,0.814 0.325,1.461 0.793,1.943c0.468,0.474 1.068,0.712 1.801,0.712c0.569,-0 1.041,-0.136 1.414,-0.407c0.366,-0.271 0.783,-0.773 1.251,-1.506l1.933,1.079c-0.299,0.508 -0.614,0.944 -0.947,1.307c-0.332,0.363 -0.688,0.661 -1.068,0.895c-0.379,0.234 -0.79,0.405 -1.23,0.514c-0.441,0.108 -0.919,0.163 -1.435,0.163c-1.478,-0 -2.665,-0.475 -3.56,-1.425c-0.895,-0.956 -1.343,-2.224 -1.343,-3.804c0,-1.567 0.434,-2.835 1.302,-3.805c0.875,-0.956 2.035,-1.434 3.479,-1.434c1.458,-0 2.611,0.465 3.459,1.394c0.841,0.922 1.261,2.2 1.261,3.835l-0.01,0.539Zm-2.35,-1.872c-0.319,-1.221 -1.088,-1.831 -2.309,-1.831c-0.278,0 -0.539,0.042 -0.783,0.127c-0.244,0.085 -0.467,0.207 -0.667,0.366c-0.2,0.16 -0.371,0.351 -0.513,0.575c-0.143,0.224 -0.251,0.478 -0.326,0.763l4.598,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M213.206,753.319l2.289,-0l0,0.885c0.421,-0.441 0.794,-0.743 1.119,-0.906c0.333,-0.169 0.726,-0.254 1.18,-0.254c0.604,-0 1.235,0.197 1.892,0.59l-1.047,2.096c-0.434,-0.312 -0.858,-0.468 -1.272,-0.468c-1.248,-0 -1.872,0.942 -1.872,2.828l0,5.137l-2.289,-0l0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M229.879,758.812l-7.1,-0c0.061,0.814 0.325,1.461 0.793,1.943c0.468,0.474 1.068,0.712 1.801,0.712c0.569,-0 1.041,-0.136 1.414,-0.407c0.366,-0.271 0.783,-0.773 1.251,-1.506l1.933,1.079c-0.299,0.508 -0.614,0.944 -0.946,1.307c-0.333,0.363 -0.689,0.661 -1.068,0.895c-0.38,0.234 -0.79,0.405 -1.231,0.514c-0.441,0.108 -0.919,0.163 -1.435,0.163c-1.478,-0 -2.665,-0.475 -3.56,-1.425c-0.895,-0.956 -1.343,-2.224 -1.343,-3.804c0,-1.567 0.434,-2.835 1.302,-3.805c0.875,-0.956 2.035,-1.434 3.479,-1.434c1.458,-0 2.611,0.465 3.459,1.394c0.841,0.922 1.261,2.2 1.261,3.835l-0.01,0.539Zm-2.35,-1.872c-0.318,-1.221 -1.088,-1.831 -2.309,-1.831c-0.278,0 -0.539,0.042 -0.783,0.127c-0.244,0.085 -0.466,0.207 -0.666,0.366c-0.2,0.16 -0.372,0.351 -0.514,0.575c-0.143,0.224 -0.251,0.478 -0.326,0.763l4.598,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M248.129,749.86l-1.923,1.139c-0.359,-0.624 -0.702,-1.03 -1.027,-1.22c-0.339,-0.217 -0.777,-0.326 -1.313,-0.326c-0.657,0 -1.203,0.187 -1.637,0.56c-0.434,0.366 -0.651,0.827 -0.651,1.383c-0,0.766 0.569,1.384 1.709,1.851l1.566,0.641c1.275,0.516 2.208,1.145 2.798,1.887c0.59,0.743 0.885,1.653 0.885,2.732c-0,1.444 -0.482,2.638 -1.445,3.58c-0.97,0.95 -2.173,1.425 -3.611,1.425c-1.363,-0 -2.489,-0.404 -3.377,-1.211c-0.875,-0.807 -1.421,-1.943 -1.638,-3.408l2.401,-0.529c0.108,0.923 0.298,1.56 0.569,1.913c0.488,0.678 1.201,1.017 2.136,1.017c0.74,-0 1.353,-0.248 1.842,-0.743c0.488,-0.495 0.732,-1.122 0.732,-1.882c0,-0.305 -0.042,-0.585 -0.127,-0.839c-0.085,-0.254 -0.217,-0.488 -0.397,-0.702c-0.18,-0.213 -0.412,-0.413 -0.697,-0.6c-0.284,-0.186 -0.624,-0.364 -1.017,-0.534l-1.516,-0.631c-2.149,-0.908 -3.224,-2.238 -3.224,-3.987c-0,-1.18 0.451,-2.167 1.353,-2.961c0.902,-0.8 2.024,-1.2 3.367,-1.2c1.81,0 3.224,0.882 4.242,2.645Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M253.245,768.618l-2.288,0l-0,-15.299l2.288,-0l0,1.078c0.902,-0.902 1.926,-1.353 3.073,-1.353c1.363,-0 2.485,0.502 3.367,1.506c0.895,0.996 1.342,2.254 1.342,3.774c0,1.485 -0.444,2.722 -1.332,3.713c-0.882,0.983 -1.994,1.475 -3.337,1.475c-1.159,-0 -2.197,-0.465 -3.113,-1.394l0,6.5Zm5.443,-10.284c-0,-0.95 -0.258,-1.723 -0.773,-2.32c-0.523,-0.603 -1.18,-0.905 -1.974,-0.905c-0.841,0 -1.522,0.292 -2.044,0.875c-0.523,0.583 -0.784,1.349 -0.784,2.299c0,0.929 0.261,1.695 0.784,2.299c0.515,0.59 1.193,0.885 2.034,0.885c0.793,-0 1.448,-0.299 1.963,-0.895c0.529,-0.597 0.794,-1.343 0.794,-2.238Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M262.981,758.201c-0,-1.43 0.512,-2.648 1.536,-3.651c1.024,-1.004 2.272,-1.506 3.743,-1.506c1.479,-0 2.733,0.505 3.764,1.516c1.017,1.01 1.526,2.251 1.526,3.723c-0,1.485 -0.512,2.729 -1.536,3.733c-1.031,0.997 -2.296,1.496 -3.795,1.496c-1.485,-0 -2.729,-0.509 -3.733,-1.526c-1.004,-1.004 -1.505,-2.265 -1.505,-3.785Zm2.339,0.041c0,0.99 0.265,1.774 0.794,2.35c0.542,0.583 1.258,0.875 2.146,0.875c0.895,-0 1.611,-0.288 2.147,-0.865c0.535,-0.576 0.803,-1.346 0.803,-2.309c0,-0.963 -0.268,-1.733 -0.803,-2.309c-0.543,-0.583 -1.258,-0.875 -2.147,-0.875c-0.875,0 -1.583,0.292 -2.126,0.875c-0.542,0.583 -0.814,1.336 -0.814,2.258Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M275.971,753.319l2.299,-0l-0,0.915c0.8,-0.793 1.702,-1.19 2.706,-1.19c1.153,-0 2.051,0.363 2.696,1.088c0.556,0.618 0.834,1.625 0.834,3.022l-0,6.073l-2.299,-0l-0,-5.534c-0,-0.977 -0.136,-1.651 -0.407,-2.024c-0.265,-0.38 -0.746,-0.57 -1.445,-0.57c-0.759,-0 -1.298,0.251 -1.617,0.753c-0.312,0.495 -0.468,1.359 -0.468,2.594l-0,4.781l-2.299,-0l-0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M293.152,755.007l-1.892,1.007c-0.298,-0.61 -0.668,-0.915 -1.109,-0.915c-0.21,-0 -0.39,0.069 -0.539,0.208c-0.149,0.139 -0.224,0.317 -0.224,0.534c0,0.38 0.441,0.757 1.323,1.13c1.214,0.522 2.031,1.003 2.451,1.444c0.421,0.441 0.631,1.034 0.631,1.78c0,0.956 -0.352,1.757 -1.058,2.401c-0.685,0.61 -1.512,0.916 -2.482,0.916c-1.661,-0 -2.838,-0.811 -3.53,-2.432l1.953,-0.905c0.272,0.475 0.479,0.776 0.621,0.905c0.278,0.258 0.61,0.387 0.997,0.387c0.773,-0 1.159,-0.353 1.159,-1.058c0,-0.407 -0.298,-0.787 -0.895,-1.139c-0.23,-0.116 -0.461,-0.228 -0.691,-0.336c-0.231,-0.109 -0.465,-0.221 -0.702,-0.336c-0.665,-0.325 -1.133,-0.651 -1.404,-0.976c-0.346,-0.414 -0.519,-0.946 -0.519,-1.597c0,-0.862 0.295,-1.574 0.885,-2.137c0.604,-0.563 1.336,-0.844 2.197,-0.844c1.269,-0 2.211,0.654 2.828,1.963Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M295.38,758.201c0,-1.43 0.512,-2.648 1.536,-3.651c1.024,-1.004 2.272,-1.506 3.744,-1.506c1.478,-0 2.733,0.505 3.763,1.516c1.018,1.01 1.526,2.251 1.526,3.723c0,1.485 -0.512,2.729 -1.536,3.733c-1.031,0.997 -2.295,1.496 -3.794,1.496c-1.485,-0 -2.73,-0.509 -3.733,-1.526c-1.004,-1.004 -1.506,-2.265 -1.506,-3.785Zm2.34,0.041c-0,0.99 0.264,1.774 0.793,2.35c0.543,0.583 1.258,0.875 2.147,0.875c0.895,-0 1.61,-0.288 2.146,-0.865c0.536,-0.576 0.804,-1.346 0.804,-2.309c-0,-0.963 -0.268,-1.733 -0.804,-2.309c-0.542,-0.583 -1.258,-0.875 -2.146,-0.875c-0.875,0 -1.584,0.292 -2.126,0.875c-0.543,0.583 -0.814,1.336 -0.814,2.258Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M308.37,753.319l2.289,-0l0,0.885c0.421,-0.441 0.794,-0.743 1.119,-0.906c0.333,-0.169 0.726,-0.254 1.18,-0.254c0.604,-0 1.234,0.197 1.892,0.59l-1.047,2.096c-0.434,-0.312 -0.858,-0.468 -1.272,-0.468c-1.248,-0 -1.872,0.942 -1.872,2.828l0,5.137l-2.289,-0l0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M325.043,758.812l-7.1,-0c0.061,0.814 0.325,1.461 0.793,1.943c0.468,0.474 1.068,0.712 1.801,0.712c0.569,-0 1.041,-0.136 1.414,-0.407c0.366,-0.271 0.783,-0.773 1.251,-1.506l1.933,1.079c-0.299,0.508 -0.614,0.944 -0.946,1.307c-0.333,0.363 -0.689,0.661 -1.068,0.895c-0.38,0.234 -0.79,0.405 -1.231,0.514c-0.441,0.108 -0.919,0.163 -1.435,0.163c-1.478,-0 -2.665,-0.475 -3.56,-1.425c-0.895,-0.956 -1.343,-2.224 -1.343,-3.804c0,-1.567 0.434,-2.835 1.302,-3.805c0.875,-0.956 2.035,-1.434 3.479,-1.434c1.458,-0 2.611,0.465 3.459,1.394c0.841,0.922 1.261,2.2 1.261,3.835l-0.01,0.539Zm-2.35,-1.872c-0.318,-1.221 -1.088,-1.831 -2.309,-1.831c-0.278,0 -0.539,0.042 -0.783,0.127c-0.244,0.085 -0.466,0.207 -0.666,0.366c-0.2,0.16 -0.372,0.351 -0.514,0.575c-0.143,0.224 -0.251,0.478 -0.326,0.763l4.598,0Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M327.546,753.319l2.299,-0l-0,0.915c0.8,-0.793 1.702,-1.19 2.706,-1.19c1.152,-0 2.051,0.363 2.695,1.088c0.556,0.618 0.834,1.625 0.834,3.022l0,6.073l-2.299,-0l0,-5.534c0,-0.977 -0.135,-1.651 -0.407,-2.024c-0.264,-0.38 -0.746,-0.57 -1.444,-0.57c-0.76,-0 -1.299,0.251 -1.617,0.753c-0.312,0.495 -0.468,1.359 -0.468,2.594l-0,4.781l-2.299,-0l-0,-9.908Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M339.325,762.087c0,-0.379 0.139,-0.708 0.417,-0.986c0.279,-0.278 0.611,-0.417 0.997,-0.417c0.387,-0 0.719,0.139 0.997,0.417c0.278,0.278 0.417,0.61 0.417,0.997c0,0.393 -0.139,0.729 -0.417,1.007c-0.271,0.271 -0.603,0.407 -0.997,0.407c-0.4,-0 -0.735,-0.136 -1.007,-0.407c-0.271,-0.272 -0.407,-0.611 -0.407,-1.018Zm0,-7.649c0,-0.373 0.139,-0.699 0.417,-0.977c0.279,-0.278 0.611,-0.417 0.997,-0.417c0.387,-0 0.719,0.139 0.997,0.417c0.278,0.278 0.417,0.61 0.417,0.997c0,0.393 -0.139,0.729 -0.417,1.007c-0.271,0.271 -0.603,0.407 -0.997,0.407c-0.393,-0 -0.729,-0.139 -1.007,-0.417c-0.271,-0.271 -0.407,-0.61 -0.407,-1.017Z"
   style="fill:#fff;fill-rule:nonzero;" />
  <path
   d="M422.445,984.012l0,1.432l-1.977,0l-0.293,2.336l1.806,-0l0,1.432l-1.985,0l-0.48,3.89l-1.433,-0.187l0.464,-3.703l-2.417,0l-0.488,3.89l-1.449,-0.187l0.464,-3.735l-1.855,-0l-0,-1.4l2.059,-0l0.293,-2.336l-1.88,0l-0,-1.432l2.059,0l0.447,-3.646l1.424,0.187l-0.431,3.459l2.401,0l0.456,-3.646l1.424,0.187l-0.432,3.459l1.823,0Zm-3.45,1.432l-2.393,0l-0.293,2.336l2.409,-0l0.277,-2.336Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M430.014,980.48l3.271,8.399l3.418,-9.009l3.272,9.009l3.475,-8.399l2.059,0l-5.616,13.363l-3.231,-8.903l-3.369,8.911l-5.338,-13.371l2.059,0Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M452.971,989.513l-5.68,0c0.049,0.651 0.26,1.17 0.635,1.555c0.374,0.38 0.854,0.569 1.44,0.569c0.456,0 0.833,-0.108 1.131,-0.325c0.293,-0.217 0.627,-0.619 1.001,-1.205l1.546,0.863c-0.238,0.407 -0.491,0.756 -0.757,1.046c-0.265,0.29 -0.55,0.529 -0.854,0.716c-0.304,0.187 -0.632,0.324 -0.985,0.411c-0.352,0.087 -0.735,0.13 -1.147,0.13c-1.183,0 -2.132,-0.38 -2.848,-1.139c-0.717,-0.765 -1.075,-1.78 -1.075,-3.044c0,-1.253 0.348,-2.268 1.042,-3.043c0.7,-0.765 1.628,-1.148 2.783,-1.148c1.167,0 2.089,0.372 2.767,1.115c0.673,0.738 1.009,1.761 1.009,3.068l-0.008,0.431Zm-1.88,-1.497c-0.255,-0.977 -0.871,-1.465 -1.847,-1.465c-0.223,0 -0.431,0.034 -0.627,0.102c-0.195,0.068 -0.373,0.165 -0.533,0.293c-0.16,0.127 -0.297,0.281 -0.411,0.46c-0.114,0.179 -0.201,0.382 -0.26,0.61l3.678,0Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M454.973,985.119l1.831,-0l0,0.708c0.336,-0.353 0.635,-0.594 0.895,-0.724c0.266,-0.136 0.581,-0.204 0.944,-0.204c0.483,0 0.988,0.157 1.514,0.472l-0.838,1.677c-0.347,-0.25 -0.687,-0.375 -1.018,-0.375c-0.998,0 -1.497,0.754 -1.497,2.263l0,4.109l-1.831,0l0,-7.926Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M463.038,979.3l-0,6.738c0.732,-0.759 1.562,-1.139 2.49,-1.139c1.069,0 1.959,0.399 2.669,1.196c0.711,0.793 1.066,1.78 1.066,2.963c0,1.22 -0.358,2.229 -1.074,3.027c-0.711,0.792 -1.608,1.188 -2.694,1.188c-0.916,0 -1.736,-0.352 -2.457,-1.058l-0,0.83l-1.831,0l-0,-13.745l1.831,0Zm4.354,9.839c-0,-0.76 -0.207,-1.378 -0.619,-1.855c-0.418,-0.489 -0.941,-0.733 -1.57,-0.733c-0.673,0 -1.221,0.236 -1.644,0.708c-0.418,0.467 -0.627,1.074 -0.627,1.823c0,0.77 0.206,1.386 0.619,1.847c0.412,0.472 0.954,0.708 1.627,0.708c0.635,0 1.161,-0.236 1.579,-0.708c0.423,-0.477 0.635,-1.074 0.635,-1.79Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M473.031,985.119l0,4.549c0,1.313 0.518,1.969 1.555,1.969c1.036,0 1.554,-0.656 1.554,-1.969l0,-4.549l1.831,-0l0,4.59c0,0.634 -0.079,1.182 -0.236,1.644c-0.152,0.412 -0.415,0.784 -0.789,1.114c-0.619,0.538 -1.405,0.806 -2.36,0.806c-0.95,0 -1.734,-0.268 -2.352,-0.806c-0.38,-0.33 -0.649,-0.702 -0.806,-1.114c-0.152,-0.369 -0.228,-0.917 -0.228,-1.644l0,-4.59l1.831,-0Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M480.282,985.119l1.839,-0l0,0.732c0.641,-0.634 1.362,-0.952 2.165,-0.952c0.922,0 1.641,0.29 2.157,0.871c0.445,0.494 0.667,1.299 0.667,2.417l0,4.858l-1.839,0l-0,-4.427c-0,-0.781 -0.109,-1.321 -0.326,-1.619c-0.211,-0.304 -0.596,-0.456 -1.155,-0.456c-0.608,0 -1.039,0.201 -1.294,0.602c-0.25,0.396 -0.375,1.088 -0.375,2.075l0,3.825l-1.839,0l0,-7.926Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <path
   d="M497.087,992.858c0,0.374 -0.012,0.704 -0.036,0.989c-0.025,0.285 -0.059,0.536 -0.102,0.753c-0.13,0.596 -0.385,1.109 -0.765,1.538c-0.716,0.824 -1.701,1.237 -2.954,1.237c-1.058,-0 -1.929,-0.285 -2.612,-0.855c-0.706,-0.586 -1.113,-1.397 -1.221,-2.433l1.839,-0c0.071,0.391 0.187,0.692 0.35,0.903c0.38,0.494 0.933,0.741 1.66,0.741c1.34,-0 2.01,-0.822 2.01,-2.466l0,-1.107c-0.727,0.744 -1.565,1.115 -2.514,1.115c-1.08,0 -1.964,-0.39 -2.653,-1.172c-0.695,-0.792 -1.042,-1.782 -1.042,-2.97c-0,-1.156 0.323,-2.138 0.968,-2.946c0.695,-0.857 1.612,-1.286 2.751,-1.286c0.998,0 1.828,0.372 2.49,1.115l0,-0.895l1.831,-0l0,7.739Zm-1.758,-3.76c0,-0.77 -0.206,-1.386 -0.618,-1.847c-0.418,-0.472 -0.952,-0.708 -1.603,-0.708c-0.695,0 -1.243,0.258 -1.644,0.773c-0.364,0.461 -0.545,1.058 -0.545,1.79c-0,0.722 0.181,1.313 0.545,1.775c0.396,0.504 0.944,0.756 1.644,0.756c0.7,0 1.253,-0.255 1.66,-0.765c0.374,-0.461 0.561,-1.052 0.561,-1.774Z"
   style="fill:#fff;fill-opacity:0.61;fill-rule:nonzero;" />
  <rect x="117" y="21" width="11" height="9" style="fill:#ffd900;" />
  <path
   d="M482.757,734.25c0,-0.414 -0.336,-0.75 -0.75,-0.75l-464.014,0c-0.414,0 -0.75,0.336 -0.75,0.75l-0,1.5c-0,0.414 0.336,0.75 0.75,0.75l464.014,0c0.414,0 0.75,-0.336 0.75,-0.75l0,-1.5Z"
   style="fill:#fff;fill-opacity:0.27;" />
 </g>
   </svg>

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
