//
//  AktionenView.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct AktionenView: View {
	@ObservedObject var verwaltung: Verwaltung
	@Binding var selectedPersonen: [Person]
	@State var aktionObserver: AktionObserver

	var body: some View {
		Text("Und los")
		Button(action: {
			DispatchQueue.global(qos: .default).async {
				Aktion.fetchFromGoogleForm(verwaltung: verwaltung, ao: aktionObserver)
			}
		}) {
			Text("fill out from google forms")
		}
	}
}
