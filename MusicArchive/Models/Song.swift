//
//  Song.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation

class Song {
    var name: String?
    var recordedDate: Date?
    var artists: [Artist]?

    init(_ dictionary: [String:Any]) {
        name = dictionary["name"] as? String

        // Set recorded date
        if let recordedDateString = dictionary["recorded_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
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
