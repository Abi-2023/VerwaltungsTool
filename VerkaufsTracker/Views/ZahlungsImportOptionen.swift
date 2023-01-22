//
//  ZahlungsImportOptionen.swift
//  
//
//  Created by Benedict on 22.01.23.
//

import SwiftUI

enum MyError: Error {
	case runtimeError(String)
}

struct ZahlungsImportOptionen: View {
	@ObservedObject var zahlungsVerarbeiter: ZahlungsVerarbeiter

	@State var showDocumentPicker = true

	var body: some View {
		Text("Hello, World!")
			.fileImporter(isPresented: $showDocumentPicker,
						  allowedContentTypes: [.commaSeparatedText],
								  allowsMultipleSelection: false)
					{ result in
						do {
							guard let file = try result.get().first else {
								throw MyError.runtimeError("keine Datei ausgewählt")
							}

							let data = try Data(contentsOf: file)
							guard let fileStr = String(data: data, encoding: .utf8) else {
								throw MyError.runtimeError("Datei konnte nicht gelesen werden")
							}
							print(fileStr)

						} catch {
							print("error: \(error)")
						}

					}
	}
}
