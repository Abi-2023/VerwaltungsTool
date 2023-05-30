//
//  Extensions.swift
//  
//
//  Created by Benedict on 25.12.22.
//

import Foundation
import CryptoKit

extension Array where Element: Hashable{

	mutating func toggle(e: (Element)) {
		if self.contains(e) {
			self.removeAll(where: {$0 == e})
		} else {
			self.append(e)
		}
	}
}

extension SymmetricKey {

	// MARK: Custom Initializers

	/// Creates a `SymmetricKey` from a Base64-encoded `String`.
	///
	/// - Parameter base64EncodedString: The Base64-encoded string from which to generate the `SymmetricKey`.
	init?(base64EncodedString: String) {
		guard let data = Data(base64Encoded: base64EncodedString) else {
			return nil
		}

		self.init(data: data)
	}

	// MARK: - Instance Methods

	/// Serializes a `SymmetricKey` to a Base64-encoded `String`.
	func serialize() -> String {
		return self.withUnsafeBytes { body in
			Data(body).base64EncodedString()
		}
	}
}

extension Int {
	var geldStr: String {
		let cents = self % 100
		let euro = (self - cents) / 100
		let extra = cents % 100 == 0 ? "0" : ""
		let leadingZero = cents < 10 && cents != 0 ? "0" : ""
		return "\(euro),\(leadingZero)\(abs(cents))\(extra) €"
	}
}

#if !os(macOS)
import SwiftUI
extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

extension NSRegularExpression {
	static func getMatches(regex: String, inputText: String) -> [String] {

		guard let regex = try? NSRegularExpression(pattern: regex) else {
			return []
		}
		let results = regex.matches(in: inputText,
								range: NSRange(inputText.startIndex..., in: inputText))

		let finalResult = results.map { match in

			return (0..<match.numberOfRanges).map { range -> String in

				let rangeBounds = match.range(at: range)
				guard let range = Range(rangeBounds, in: inputText) else {
					return ""
				}
				return String(inputText[range])
			}
		}.filter { !$0.isEmpty }

		var allMatches: [String] = []

		// Iterate over the final result which includes all the matches and groups
		// We will store all the matching strings
		for result in finalResult {
			for (index, resultText) in result.enumerated() {

				// Skip the match. Go to the next elements which represent matching groups
				if index == 0 {
					continue
				}
				allMatches.append(resultText)
			}
		}

		return allMatches
	}

	convenience init(_ pattern: String) {
			do {
				try self.init(pattern: pattern)
			} catch {
				preconditionFailure("Illegal regular expression: \(pattern).")
			}
		}
}

#endif


extension Date {
		func timeAgoDisplay() -> String {
			let calendar = Calendar.current
			let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
			let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
			let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
			let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
			if minuteAgo < self {
				let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
				return "vor \(diff) Sekunden"
			} else if hourAgo < self {
				let diffMin = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
				let diffSec = (Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0) - diffMin * 60
				return "vor \(diffMin) Minuten und \(diffSec) Sekunden"
			} else if dayAgo < self {
				let diffHour = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
				let diffMin = (Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0) - diffHour * 60
				let diffSec = (Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0) - diffMin * 60 - diffHour * 60 * 60
				return "vor \(diffHour)h \(diffMin)m \(diffSec)s"
			} else if weekAgo < self {
				let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
				return "vor \(diff) Tagen"
			}
			let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
			return "\(diff) weeks ago"
		}
	}
