//
//  TabBarViewController.swift
//  MusicArchive
//
//  Created by Joshua on 9/7/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

enum Page:Int {
    case home, artists, albums, songs, search
}

class TabBarController: UITabBarController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        load()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        load()
    }

    func load() { delegate = self }

    func goToSongs(artist: Artist?) {
        let songsVC = viewControllers?[Page.songs.rawValue] as? SongsViewController
        songsVC?.artist = artist
        songsVC?.songsTablePlayerView?.page = 1
        songsVC?.fetchSongs()
        
        // Present VC
        selectedIndex = Page.songs.rawValue
    }
    
    func goToSongs(search: String) {
        // TODO Implement search
        let songsVC = viewControllers?[Page.songs.rawValue] as? SongsViewController
        songsVC?.songs = []
        songsVC?.songsTablePlayerView?.page = 1
        songsVC?.fetchSongs()
        
        // Present VC
        selectedIndex = Page.songs.rawValue
    }

}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Reset SongsVC artist to nil if not transitioning with goToSongs()
        if let songsVC = viewController as? SongsViewController {
            songsVC.artist = nil
            songsVC.songsTablePlayerView.page = 1
            songsVC.fetchSongs()
        }
    }

}
