//
//  Ticket.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import Foundation
import SwiftUI
import SwiftSMTP

class Ticket: Codable {
	let id: String
	var versendet: Bool
	let itemType: Item // ob das Ticket für die after show ist
	let owner: UUID
	let nth: Int

	init(owner: Person, type: Item, nth: Int) {
		id = UUID().uuidString
		versendet = false
		self.itemType = type
		self.owner = owner.id
		self.nth = nth
	}

	func generateAttatchment(verwaltung v: Verwaltung) -> Attachment{
		let ticketPdfData = exportTicketToPDFData(verwaltung: v)
		// TODO: PDF komprimieren
		let dataAttachment = Attachment(
			data: ticketPdfData,
			mime: "application/pdf",
			name: "ticket.pdf",
			inline: false
		)
		return dataAttachment
	}

	func exportTicketToPDFData(verwaltung v: Verwaltung) -> Data {
		let renderer = CustomPrintPageRenderer()
		let pdfData = renderer.exportHTMLContentToPDFData(HTMLContent: self.ticketHTML(verwaltung: v))

		return pdfData
	}

}

func exportToPDFAndOpenDialog(ticket: Ticket, verwaltung: Verwaltung) {
	let pdfData = ticket.exportTicketToPDFData(verwaltung: verwaltung)
	let activityViewController = UIActivityViewController(activityItems: [pdfData],
														  applicationActivities: nil)


	let viewController = Coordinator.topViewController()
	activityViewController.popoverPresentationController?.sourceView = viewController?.view
	viewController?.present(activityViewController, animated: true, completion: nil)
}


enum Coordinator {
	static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
		let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
		let viewCon = viewController ?? windowScene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
		if let navigationController = viewCon as? UINavigationController {
			return topViewController(navigationController.topViewController)
		} else if let tabBarController = viewCon as? UITabBarController {
			return tabBarController.presentedViewController != nil ?
			topViewController(tabBarController.presentedViewController) :
			topViewController(tabBarController.selectedViewController)
		} else if let presentedViewController = viewCon?.presentedViewController {
			return topViewController(presentedViewController)
		}
		return viewCon
	}
}
