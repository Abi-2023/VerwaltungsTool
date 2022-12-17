//
//  ContentView.swift
//  
//
//  Created by Benedict on 13.12.22.
//

import SwiftUI
#if canImport(CodeScanner)
import CodeScanner
#endif

struct ContentView: View {
	@State private var isShowingScanner = false
	@State var image: UIImage?


	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
		}
		.padding()
		.onAppear {
			let x2 = VerifyTicket()
			var x = QrCodeImage()
			image = x.generateQRCode(from: "abc")
			print(image)
		}

		if let image2 = image {
			Image(uiImage: image2)
				.resizable()
//				.scaleEffect(2)
//				.foregroundColor(.blue)
//				.background(.red)
				.scaledToFit()
		}


		Button(action: {
			let mailer = EmailManager()
			mailer.sendEmail(recipientAdress: "***REMOVED***", recipientName: "Bene", subject: "Testemail", text: "Diese Email wurde automatisiert versendet. \(UUID())")
		}) {
			Text("Send Email")
		}

#if canImport(CodeScanner)
		Button(action: {
			isShowingScanner = true
		}) {
			Text("Scan")
		}
		.sheet(isPresented: $isShowingScanner) {
			CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
		}
		.padding()





#endif
    }
#if canImport(CodeScanner)
	func handleScan(result: Result<ScanResult, ScanError>) {
	   isShowingScanner = false

		print(result)
	   // more code to come
	}
	#endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct QrCodeImage {
    let context = CIContext()

    func generateQRCode(from text: String) -> UIImage {
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        let data = Data(text.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 20, y: 20)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let image = context.createCGImage(
                outputImage,
                from: outputImage.extent) {
                qrImage = UIImage(cgImage: image)
            }
        }
        return qrImage
    }
}
