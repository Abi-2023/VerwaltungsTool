//
//  TicketGenerator.swift
//  
//
//  Created by Benedict on 06.01.23.
//

import Foundation
import SwiftSMTP
import UIKit

extension Ticket {
	func generateAttatchment(verwaltung v: Verwaltung) -> Attachment{
		let ticketPdfData = exportTicketToPDFData(verwaltung: v)
		let nameMap = [Item.ball_ticket : "ball_ticket", Item.after_show_ticket : "after_show_ticket"]
		let ticketName = "\(nameMap[itemType, default: "unbekannt"])\(nth).pdf"

		// TODO: PDF komprimieren
		let dataAttachment = Attachment(
			data: ticketPdfData,
			mime: "application/pdf",
			name: ticketName,
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
