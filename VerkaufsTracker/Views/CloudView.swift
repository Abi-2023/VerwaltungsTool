//
//  CloudView.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import SwiftUI

struct CloudView: View {
	@ObservedObject var v: Verwaltung
	var body: some View {
		Text("Server Status")
		Text("\(v.cloud.rawValue)")

		Button(action: {
			v.fetchFromCloud()
		}) {
			Text("sync")
		}
	}
}

