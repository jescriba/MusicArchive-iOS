//
//  Album.swift
//  MusicArchive
//
//  Created by Joshua Escribano on 9/9/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation

class Album {
    var id: Int?
    var name: String?

    init(_ dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
    }
}
