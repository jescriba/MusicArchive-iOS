// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }

    func toSearchString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func titleFromUrl() -> String {
        let matches = self.matches(for: "\\.([^.]+)\\.")
        if matches.isEmpty { return "Archive" }
        guard let match = matches.first else { return "Archive" }
        return match
    }

    func asValidUrl() -> String? {
        var validUrl: String? = self
        if !hasPrefix("http://www.") {
            validUrl = "http://www." + self
        }

        let title = validUrl?.titleFromUrl()
        guard title != nil, !title!.isEmpty else { return nil }

        return validUrl
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
