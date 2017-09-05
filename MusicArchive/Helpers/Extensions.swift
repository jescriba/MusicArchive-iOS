//
//  Extensions.swift
//  MusicArchive
//
//  Created by Joshua on 9/4/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation


extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
