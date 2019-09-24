// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation

class Endpoints {
  static var baseEndPoint: String {
    get {
      return UserDefaults.standard.string(forKey: "baseEndPoint") ?? "http://www.my-music-archive.com"
    } set {
      UserDefaults.standard.set(newValue, forKey: "baseEndPoint")
    }
  }

  static var artistsEndPoint = "\(Endpoints.baseEndPoint)/artists"
  static var songsEndPoint = "\(Endpoints.baseEndPoint)/songs"
  static var albumsEndPoint = "\(Endpoints.baseEndPoint)/albums"
  static var searchEndPoint = "\(Endpoints.baseEndPoint)/search"
}
