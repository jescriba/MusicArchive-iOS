// Copyright (c) 2019 Joshua Escribano-Fontanet

import Alamofire
import Foundation

// TODO: Refactor using generics
class MusicAPIClient {
  static func fetchArtists(success: @escaping ([Artist]) -> Void,
                           failure: ((Error) -> Void)? = nil) {
    Alamofire.request(Endpoints.artistsEndPoint, headers: ["Accept": "application/json"])
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let json = response.result.value {
          if let results = json as? [[String: Any]] {
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
                                   params: [String: Any]? = nil,
                                   success: @escaping ([Song]) -> Void,
                                   failure: ((Error) -> Void)? = nil) {
    var endPoint = "\(Endpoints.artistsEndPoint)/\(artistId)/songs"
    if let p = params { endPoint += "?\(p.webParameterized())" }
    Alamofire.request(endPoint, headers: ["Accept": "application/json"])
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let json = response.result.value {
          if let results = json as? [[String: Any]] {
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

  static func fetchSongsByAlbumId(_ albumId: Int,
                                  params: [String: Any]? = nil,
                                  success: @escaping ([Song]) -> Void,
                                  failure: ((Error) -> Void)? = nil) {
    var endPoint = "\(Endpoints.albumsEndPoint)/\(albumId)/songs"
    if let p = params { endPoint += "?\(p.webParameterized())" }
    Alamofire.request(endPoint, headers: ["Accept": "application/json"])
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let json = response.result.value {
          if let results = json as? [[String: Any]] {
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

  static func fetchSongs(params: [String: Any]? = nil,
                         success: @escaping ([Song]) -> Void,
                         failure: ((Error) -> Void)? = nil) {
    var endPoint = "\(Endpoints.songsEndPoint)"
    if let p = params { endPoint += "?\(p.webParameterized())" }
    Alamofire.request(endPoint, headers: ["Accept": "application/json"])
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let json = response.result.value {
          if let results = json as? [[String: Any]] {
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

  static func fetchAlbums(params: [String: Any]? = nil,
                          success: @escaping ([Album]) -> Void,
                          failure: ((Error) -> Void)? = nil) {
    var endPoint = "\(Endpoints.albumsEndPoint)"
    if let p = params { endPoint += "?\(p.webParameterized())" }
    Alamofire.request(endPoint, headers: ["Accept": "application/json"])
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let json = response.result.value {
          if let results = json as? [[String: Any]] {
            var albums = [Album]()
            for result in results {
              albums.append(Album(result))
            }
            success(albums)
          }
        }

        if let error = response.result.error {
          failure?(error)
        }
      }
  }

  static func searchSongs(_ params: [String: Any],
                          success: @escaping ([Song]) -> Void,
                          failure: ((Error) -> Void)? = nil) {
    let searchEndPoint = "\(Endpoints.searchEndPoint)?\(params.webParameterized())"
    Alamofire.request(searchEndPoint, headers: ["Accept": "application/json"])
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let json = response.result.value {
          if let results = json as? [[String: Any]] {
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
