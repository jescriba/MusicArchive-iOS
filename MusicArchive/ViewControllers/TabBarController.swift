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

protocol ContainerDelegate {
    var containerView: UIView { get }
}

class TabBarController: UITabBarController {
    fileprivate var hasSongControls: Bool = false
    fileprivate var playerView: SongPlayerView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        load()
    }

    func load() {
        delegate = self
        
        // Add song player view
        playerView = SongPlayerView(frame: view.frame)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        playerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
        playerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view.bringSubview(toFront: tabBar)
    }

    func goToSongs(artist: Artist? = nil, album: Album? = nil) {
        let songsVC = viewControllers?[Page.songs.rawValue] as? SongsViewController
        
        if let artist = artist {
            songsVC?.isPaging = false
            songsVC?.detailTitle = artist.name
            songsVC?.fetchSongs(artist: artist)
        }
        
        if let album = album {
            songsVC?.isPaging = false
            songsVC?.detailTitle = album.name
            songsVC?.songs = album.songs ?? [Song]()
        }
        
        // Present VC
        selectedIndex = Page.songs.rawValue
    }
    
    func goToSongs(search: [String:Any]) {
        // TODO Implement search
        let songsVC = viewControllers?[Page.songs.rawValue] as? SongsViewController
        songsVC?.loadViewIfNeeded() // Preventing nil when using IBOutlet before load
        songsVC?.songs = []
        songsVC?.detailTitle = "search"
        songsVC?.searchSongs(search)
        
        // Present VC
        selectedIndex = Page.songs.rawValue
    }

}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Allow for spacing on the footer
        // Reset SongsVC detail title if not transitioning with goToSongs()
        if let songsVC = viewController as? SongsViewController {
            songsVC.detailTitleLabel.text = ""
            songsVC.isPaging = true
            songsVC.fetchSongs()
        }
    }

}

extension TabBarController: SongPlayerViewDelegate {

    func updateSong(_ s: Song) {
        playerView.song = s
    }
    
    func updatePlayState(_ s: PlayState) {
        playerView.playState = s
    }
    
}
