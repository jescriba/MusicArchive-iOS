//
//  MusicAPIClient.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import Alamofire

class MusicAPIClient {

    static func fetchArtists(success: @escaping ([Artist]) -> (),
                             failure: ((Error) -> ())? = nil) {
        Alamofire.request(Constants.artistsEndPoint, headers: ["Accept":"application/json"])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
            if let json = response.result.value {
                if let results = json as? [[String:Any]] {
                    var artists = [Artist]()
                    for result in results {
                        artists.append(Artist(result))
                    }
                    success(artists)
                }
            }

            if let error = response.result.error {
                failure?(error)
            }
        }
    }

    static func fetchSongsByArtistId(_ artistId: Int,
                           params: [String:Any]? = nil,
                           success: @escaping ([Song]) -> (),
                           failure: ((Error) -> ())? = nil) {
        var endPoint = "\(Constants.artistsEndPoint)/\(artistId)/songs"
        if let p = params { endPoint += "?\(p.webParameterized())" }
        Alamofire.request(endPoint, headers: ["Accept":"application/json"])
                 .validate(contentType: ["application/json"])
                 .responseJSON { response in
                    if let json = response.result.value {
                        if let results = json as? [[String:Any]] {
                            var songs = [Song]()
                            for result in results {
                                songs.append(Song(result))
                            }
                            success(songs)
                        }
                    }

                    if let error = response.result.error {
                        failure?(error)
                    }
        }
    }
    
    static func fetchSongs(params: [String:Any]? = nil,
                           success: @escaping ([Song]) -> (),
                           failure: ((Error) -> ())? = nil) {
        var endPoint = "\(Constants.songsEndPoint)"
        if let p = params { endPoint += "?\(p.webParameterized())" }
        Alamofire.request(endPoint, headers: ["Accept":"application/json"])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if let json = response.result.value {
                    if let results = json as? [[String:Any]] {
                        var songs = [Song]()
                        for result in results {
                            songs.append(Song(result))
                        }
                        success(songs)
                    }
                }

                if let error = response.result.error {
                    failure?(error)
                }
        }
    }

    static func searchSongs(artistName: String? = nil,
                           startDate: Date? = nil,
                           endDate: Date? = nil,
                           success: @escaping ([Song]) -> (),
                           failure: ((Error) -> ())? = nil) {
        
        // Ideally search would look like /songs?name=test&artist=something&recorded_
        var searchEndPoint = Constants.songsEndPoint

        if let startDate = startDate {
            // TODO
        }

        if let endDate = endDate {
            // TODO
        }

        if let artistName = artistName {
            // TODO
        }

        Alamofire.request(searchEndPoint, headers: ["Accept":"application/json"])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if let json = response.result.value {
                    if let results = json as? [[String:Any]] {
                        var songs = [Song]()
                        for result in results {
                            songs.append(Song(result))
                        }
                        success(songs)
                    }
                }

                if let error = response.result.error {
                    failure?(error)
                }
        }
    }

}
