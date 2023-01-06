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
        ZStack{
			VStack(spacing: 10){
				HStack(alignment: .top){
					VStack(alignment: .leading, spacing: 5){
						Text("Log").font(.largeTitle.weight(.heavy))
						Text(ao.prompt).font(.title.bold())
					}
					Spacer()
					if(ao.finished) {
						Button(action: {
							ao.clear()
						}) {
							Text("Fertig").bold()
						}
						
					}
				}
				Divider()
				ScrollView(showsIndicators: false){
					Text(ao.log)
					
					Spacer()
				}
			}
        }.padding()
	}
}
