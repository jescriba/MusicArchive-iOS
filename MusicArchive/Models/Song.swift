//
//  Song.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation

class Song {
    var id: Int?
    var name: String?
    var recordedDate: Date?
    var url: URL?
    var artists: [Artist]?

    init(_ dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String

        // Set recorded date
        if let recordedDateString = dictionary["recorded_date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            recordedDate = dateFormatter.date(from: recordedDateString)
        }

        // Set artists
        if let artistsDictArray = dictionary["artists"] as? [[String:Any]] {
            var tempArtists = [Artist]()
            for artistsDict in artistsDictArray {
                tempArtists.append(Artist(artistsDict))
            }
            artists = tempArtists
        }

        if let urlString = dictionary["url"] as? String {
            url = URL(string: urlString)
        }
    }

    func artistNames() -> String {
        guard let a = artists else { return "unknown" }
        var names = ""
        for artist in a {
            names += artist.name ?? "-"
            names += " "
        }
        return names
    }
}
