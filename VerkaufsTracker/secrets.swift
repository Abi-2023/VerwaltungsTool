//
//  secrets.swift
//
//
//  Created by Benedict on 16.12.22.
//

import Foundation
import CryptoKit

class SECRETS {

	//MARK: - SMTP
	public static let EMAIL_Host = "" // SMTP server address
	public static let EMAIL_Username = "" // SMTP username to login
	public static let EMAIL_Password = "" // SMTP password to login
	//MARK: public Email
	public static let EMAIL_Address = "" // SMTP outbound email address
	public static let EMAIL_Name = "" // SMTP outbound name


	//MARK: - Firebase
	public static let FB_DB_URL = ""
	public static let FB_SCOPE = ""
	public static let FB_EncryptionKey = SymmetricKey(base64EncodedString: "")!

	//MARK: - Google Sheets
	public static let FORM_ID = ""
	public static let TRANSAKTIONEN_ID = ""
	public static let FORM_ApiKey = ""

	//MARK: - Config
	public static let AKTION_UploadLogs: Bool = true

	//MARK: - SIGNING
	public static let SIGN_Key = try! Curve25519.Signing.PrivateKey(rawRepresentation: Data(base64Encoded: "")!)

	public static let TEST_MODE = false


	//MARK: - AirTable
	public static let TABLE_SCANS = ""
	public static let AIRTABLE_ACCESS_TOKEN = ""
}
