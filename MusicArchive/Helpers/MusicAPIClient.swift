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

    static func fetchArtists(success: ([Artist]) -> (),
                             failure: ((Error?) -> ())? = nil) {
        Alamofire.request(Constants.artistsEndPoint, headers: ["Accept":"application/json"])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
            if let json = response.result.value {
                
//                Artist()
            }

            if let error = response.result.error {
                // TODO
            }
        }
    }

    static func fetchSongs(artistName: String? = nil,
                           startDate: Date? = nil,
                           endDate: Date? = nil,
                           success: ([Song]) -> (),
                           failure: ((Error?) -> ())? = nil) {
        //eturn [Artist]()
        if let startDate = startDate {
            // TODO
        }

        if let endDate = endDate {
            // TODO
        }

        if let artistName = artistName {
            // TODO
        }

        Alamofire.request("").responseJSON { response in
            if let json = response.result.value {
                // TODO
            }

            if let error = response.result.error {
                // TODO
            }
        }

        
    }

}
