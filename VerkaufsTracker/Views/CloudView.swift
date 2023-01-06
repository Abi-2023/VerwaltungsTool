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
		ZStack(alignment: .center){
			HStack{
				Spacer()
				VStack{
					Spacer()
					VStack(spacing: 15){
						Text("Produktverwaltung Abi 2023").font(.largeTitle.weight(.heavy))
							.multilineTextAlignment(.center)
						
						HStack(spacing: 7.5){
							Circle().fill(v.cloud.color).frame(width: 10, height: 10)
							Text("\(v.cloud.stringGER)")
						}.foregroundColor(v.cloud.color)

						
						Button(action: {
							v.connectToCloud()
						}) {
							ZStack{
								RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
									.frame(width: 150, height: 50)
								Text("Anmelden")
									.foregroundColor(.white)
							}
						}
					}
					Spacer()
				}
				Spacer()
			}
		}.padding()
	}
}

