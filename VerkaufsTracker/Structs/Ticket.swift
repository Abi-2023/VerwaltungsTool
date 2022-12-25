//
//  Ticket.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import Foundation
import SwiftUI

class Ticket {
	let id: String
	let versendet: Bool
	let aftershow: Bool // ob das Ticket für die after show ist
	unowned let owner: Person

	init(owner: Person, aftershow: Bool = false) {
		id = UUID().uuidString
		versendet = false
		self.aftershow = aftershow
		self.owner = owner
	}
}

func exportTicketToPDF(ticket: Ticket) -> Data {
	let pageSize = CGSize(width: 500, height: 1000)

	// View to render on PDF
	let renderView = TicketRenderer(ticket: ticket)
	let myUIHostingController = UIHostingController(rootView: renderView)
	myUIHostingController.view.frame = CGRect(origin: .zero, size: pageSize)
	myUIHostingController.view.backgroundColor = UIColor.white


	// Render the view behind all other views
	let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
	let window = windowScene?.windows.first
	guard let rootVC = window?.rootViewController else {
		print("ERROR: Could not find root ViewController.")
		return Data() // TODO: throw
	}
	rootVC.addChild(myUIHostingController)
	// at: 0 -> draws behind all other views
	// at: UIApplication.shared.windows.count -> draw in front
	rootVC.view.insertSubview(myUIHostingController.view, at: 0)


	// Render the PDF
	let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
			let pdfData = pdfRenderer.pdfData(actions: { (context) in
				context.beginPage()
				myUIHostingController.view.layer.render(in: context.cgContext)
			})
		myUIHostingController.removeFromParent()
		myUIHostingController.view.removeFromSuperview()
	return pdfData
}

func exportToPDFAndOpenDialog(ticket: Ticket) {
	let pdfData = exportTicketToPDF(ticket: ticket)
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
