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
		let extra = cents % 10 == 0 ? "0" : ""
		return "\(euro),\(abs(cents))\(extra) €"
	}
}
