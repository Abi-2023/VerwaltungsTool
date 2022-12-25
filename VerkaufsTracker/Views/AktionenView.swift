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

	var body: some View {
		Text("Und los")
	}
}
