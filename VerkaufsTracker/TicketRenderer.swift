//
//  TicketRenderer.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct TicketRenderer: View {
	let ticket: Ticket
	var body: some View {
		ZStack{
			Image("TicketBackground")
			Image(uiImage: generateQRCode(from: "abc"))
				.scaleEffect(0.95)

			//TODO: Ticket Code
			//TODO: nth Ticket von Person
			//TODO: Adresse?

			Text("Gekauft von: \("Benedict ***REMOVED***")") //ticket.owner.name
				.foregroundColor(.white)
				.frame(width: 500, alignment: .leading)
				.font(.headline)
				.frame(width: 500)
			.offset(x: 50, y: -250)
		}.frame(width: 500, height: 1000)
			.background()
	}
}

struct TicketRenderer_Previews: PreviewProvider {

	static var previews: some View {
		TicketRenderer(ticket: Ticket(owner: Q2er(vorname: "Benedict", nachname: "***REMOVED***", email: "benedicts@icloud,com", notes: "", bestellungen: [:], extraFields: [:], verwaltung: Verwaltung()), type: .ball_ticket, nth: 0))
			.previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/500.0/*@END_MENU_TOKEN@*/, height: 1000))
			.frame(width: 500, height: 1000)
	}
}

func generateQRCode(from text: String) -> UIImage {
	let context = CIContext()
	var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
	let data = Data(text.utf8)
	let filter = CIFilter(name: "CIQRCodeGenerator")!
	filter.setValue(data, forKey: "inputMessage")

	let transform = CGAffineTransform(scaleX: 20, y: 20)
	if let outputImage = filter.outputImage?.transformed(by: transform) {
		let colorParameters = [
			 "inputColor0": CIColor(color: UIColor.white), // Foreground
			 "inputColor1": CIColor(color: UIColor.clear) // Background
		 ]
		 let colored = outputImage.applyingFilter("CIFalseColor", parameters: colorParameters)

		if let image = context.createCGImage(
			colored,
			from: outputImage.extent) {
			qrImage = UIImage(cgImage: image)
		}
	}

	return qrImage
}
