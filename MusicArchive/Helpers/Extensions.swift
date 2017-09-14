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

extension Dictionary where Key == String {
    func webParameterized() -> String {
        var parameterizedStr = ""
        for (key, val) in self {
            let valStr = String(describing: val).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            let keyStr = key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
            if let v = valStr, let k = keyStr {
                parameterizedStr += "\(k)=\(v)&"
            }
        }
        return parameterizedStr
    }
}
