//
//  Artist.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation

class Artist {
    var name: String?

    init(_ dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String
    }
    
}
