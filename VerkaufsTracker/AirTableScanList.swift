//
//  AirTableScanList.swift
//  
//
//  Created by Benedict on 28.05.23.
//

import Foundation

struct AirTableScanList: Codable {

  var records : [Records]? = []
  var offset  : String?    = nil

  enum CodingKeys: String, CodingKey {

	case records = "records"
	case offset  = "offset"

  }

  init(from decoder: Decoder) throws {
	let values = try decoder.container(keyedBy: CodingKeys.self)

	records = try values.decodeIfPresent([Records].self , forKey: .records )
	offset  = try values.decodeIfPresent(String.self    , forKey: .offset  )

  }

  init() {

  }

}

struct Fields: Codable {

  var ID        : String? = nil
  var Device    : String? = nil
  var TicketId  : String? = nil
  var Aktiv     : Bool?   = nil
  var TimeStamp : String? = nil

  enum CodingKeys: String, CodingKey {

	case ID        = "ID"
	case Device    = "Device"
	case TicketId  = "TicketId"
	case Aktiv     = "Aktiv"
	case TimeStamp = "TimeStamp"

  }

  init(from decoder: Decoder) throws {
	let values = try decoder.container(keyedBy: CodingKeys.self)

	ID        = try values.decodeIfPresent(String.self , forKey: .ID        )
	Device    = try values.decodeIfPresent(String.self , forKey: .Device    )
	TicketId  = try values.decodeIfPresent(String.self , forKey: .TicketId  )
	Aktiv     = try values.decodeIfPresent(Bool.self   , forKey: .Aktiv     )
	TimeStamp = try values.decodeIfPresent(String.self , forKey: .TimeStamp )

  }

  init() {

  }

}


struct Records: Codable {

  var id          : String? = nil
  var createdTime : String? = nil
  var fields      : Fields? = Fields()

  enum CodingKeys: String, CodingKey {

	case id          = "id"
	case createdTime = "createdTime"
	case fields      = "fields"

  }

  init(from decoder: Decoder) throws {
	let values = try decoder.container(keyedBy: CodingKeys.self)

	id          = try values.decodeIfPresent(String.self , forKey: .id          )
	createdTime = try values.decodeIfPresent(String.self , forKey: .createdTime )
	fields      = try values.decodeIfPresent(Fields.self , forKey: .fields      )

  }

  init() {

  }

}
