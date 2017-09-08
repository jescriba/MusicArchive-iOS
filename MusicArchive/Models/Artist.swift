//
//  Artist.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation

class Artist {
    var id: Int?
    var name: String?

    init(_ dictionary: [String:Any]) {
        self.id = dictionary["id"] as? Int
        self.name = dictionary["name"] as? String
    }
    
}
