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
    var songs: [Song]?
    var artists: [Artist]?
    var artistsNames: String? {
        guard let a = artists else { return nil }
        var val = a.reduce("", {
            (result, artist) -> String in
            "\(artist.name ?? ""), \(result)"
        })
        
        // Remove trailing comma and space
        val.removeLast(2)
        return val
    }

    init(_ dictionary: [String:Any]) {
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        
        // Assign songs
        if let songsDictionaries = dictionary["songs"] as? [[String:Any]] {
            songs = [Song]()
            for songDictionary in songsDictionaries {
                songs?.append(Song(songDictionary))
            }
        }
        
        // Assign artists
        if let artistsDictionaries = dictionary["artists"] as? [[String:Any]] {
            artists = [Artist]()
            for artistDictionary in artistsDictionaries {
                artists?.append(Artist(artistDictionary))
            }
        }
    }
}
