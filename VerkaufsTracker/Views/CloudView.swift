//
//  CloudView.swift
//  
//
//  Created by Benedict on 26.12.22.
//

import SwiftUI

struct CloudView: View {
	@ObservedObject var v: Verwaltung

	@State var deviceName = ""
	@State var refreshID = UUID()
	@Binding var state: AppState

	var body: some View {
		ZStack(alignment: .center){
			if CloudStatus.deviceName() == nil {
				HStack{
					Spacer()
					VStack{
						Spacer()
						VStack(spacing: 15){
							Text("Produktverwaltung Abi 2023").font(.largeTitle.weight(.heavy))
								.multilineTextAlignment(.center)

							Text("Bitte gib einen beschreibenden Gerätenamen ein")

							TextField("Name", text: $deviceName)
								.padding(.vertical, 20)
								.textFieldStyle(.roundedBorder)
								.onAppear {
									deviceName = UIDevice.current.name
								}


							Button(action: {
								CloudStatus.setDeviceName(name: deviceName)
								refreshID = UUID()
							}) {
								ZStack{
									RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
										.frame(width: 150, height: 50)
									Text("Speichern")
										.foregroundColor(.white)
								}
							}
						}
						Spacer()
					}
					Spacer()
				}
				.padding()
			} else {
				HStack{
					Spacer()
					VStack{
						Spacer()
						VStack(spacing: 15){
							Text("Produktverwaltung Abi 2023").font(.largeTitle.weight(.heavy))
								.multilineTextAlignment(.center)

							Text(CloudStatus.deviceName() ?? "Anonym")
								.font(.caption)
								.onTapGesture {
									CloudStatus.setDeviceName(name: nil)
									refreshID = UUID()
								}

							if let cloudStatus = v.cloudStatus {
								Text("Letzte Verbindung: \(cloudStatus.lastConnection.formatted(.dateTime))")
								Text("Von: \(cloudStatus.lastConnectionName ?? "?")")
							}

							HStack(spacing: 7.5){
								Circle().fill(v.cloud.color).frame(width: 10, height: 10)
								Text("\(v.cloud.stringGER)")
							}.foregroundColor(v.cloud.color)

							Spacer()

							Button(action: {
								let defaults = UserDefaults()
								defaults.set(true, forKey: "SCANNER_MODE")
								state = .scanner
								v.connectToCloud(scannerMode: true)
							}) {
								ZStack{
									RoundedRectangle(cornerRadius: 10).foregroundColor(.purple)
										.frame(width: 150, height: 50)
									Text("Scanner Modus")
										.foregroundColor(.white)
								}
							}

							Spacer()

							Button(action: {
								v.connectToCloud()
							}) {
								Text("Anmelden")
									.foregroundColor(.white)
							}.buttonStyle(.borderedProminent)

						}
						Spacer()
					}
					Spacer()
				}
				.padding()
			}
		}.id(refreshID)
	}
}

