//
//  VerkaufsTrackerApp.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI

enum AppState {
	case personenView, debug
}

@main
struct VerkaufsTrackerApp: App {
	@State var verwaltung = Verwaltung()
	@State var state: AppState = .personenView

	var body: some Scene {
		WindowGroup {
			VStack{
				switch state {
				case .personenView:
					PersonenView()
				case .debug:
					ContentView()
				}
				Spacer()
				HStack {
					Spacer()
					Button(action: {
						state = .personenView
					}) {
						Text("P")
					}.buttonStyle(.bordered)
					Spacer()
					Button(action: {
						state = .debug
					}) {
						Text("D")
					}.buttonStyle(.bordered)
					Spacer()
				}
			}
		}
	}
}
