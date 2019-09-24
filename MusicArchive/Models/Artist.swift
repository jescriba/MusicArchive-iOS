// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation

class Artist {
  var id: Int?
  var name: String?

  init(_ dictionary: [String: Any]) {
    id = dictionary["id"] as? Int
    name = dictionary["name"] as? String
  }
}
