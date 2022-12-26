//
//  AktionLogView.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import SwiftUI

struct AktionLogView: View {
	@ObservedObject var ao: AktionObserver
	var body: some View {

		Text(ao.prompt)

		Divider()

		Text(ao.log)

		if(ao.finished) {
			Button(action: {
				ao.aktiv = false
			}) {
				Text("fertig")
			}
			.buttonStyle(.bordered)
		}
	}
}
