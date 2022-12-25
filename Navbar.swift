//
//  Navbar.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import SwiftUI

struct Navbar: View {
	@Binding var appState: AppState
	let width: CGFloat

	@Environment(\.colorScheme) var colorScheme
	var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Divider()
				Color(UIColor.secondarySystemBackground)
					.edgesIgnoringSafeArea(.bottom)
					.shadow(radius: 1.5)
			}

			HStack {
				NavBarIcon(image: "person.3.fill",
						   width: width / 4,
						   selfState: .personenView,
						   name: "Personen",
						   state: $appState)
				.keyboardShortcut("1", modifiers: [.command])

				NavBarIcon(image: "wand.and.rays",
						   width: width / 4,
						   selfState: .aktionen,
						   name: "Aktionen",
						   state: $appState)
				.keyboardShortcut("2", modifiers: [.command])

				NavBarIcon(image: "chart.line.uptrend.xyaxis",
						   width: width / 4,
						   selfState: .stats,
						   name: "Stats",
						   state: $appState)
				.keyboardShortcut("3", modifiers: [.command])

				NavBarIcon(image: "wrench.and.screwdriver.fill",
						   width: width / 4,
						   selfState: .debug,
						   name: "Debug",
						   state: $appState)
				.keyboardShortcut("4", modifiers: [.command])
			}
			.frame(width: width, alignment: .center)
			.padding(.top, 5)

			.fixedSize()
		}.fixedSize()
	}
}

private struct NavBarIcon: View {
	let image: String
	let width: CGFloat
	let selfState: AppState
	let name: String
	@Binding var state: AppState
	var body: some View {
		Button(action: {
			state = selfState
		}) {
			VStack {
				Image(systemName: image)
					.font(.title2)
					.foregroundColor(state == selfState ? .accentColor : Color(UIColor.secondaryLabel))
					.frame(height: 25, alignment: .center)
				Text(name)
					.font(.caption2)
					.frame(height: 10)
					.foregroundColor(state == selfState ? .accentColor : .secondary)
			}
			.animation(Animation.timingCurve(0.22, 1, 0.36, 1, duration: 0.5), value: state)
		}
		.frame(width: width, alignment: .center)
		.padding(.bottom, 5)
		.contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
		.hoverEffect(.lift)
	}
}
