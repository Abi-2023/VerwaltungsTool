//
//  ContentView.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()

		Button(action: {
			let mailer = EmailManager()
			mailer.sendEmail(recipientAdress: "***REMOVED***", recipientName: "Bene", subject: "Testemail", text: "Diese Email wurde automatisiert versendet. \(UUID())")
		}) {
			Text("Send Email")
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
