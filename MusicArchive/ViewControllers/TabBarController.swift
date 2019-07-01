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
    var isCollapsed = true
    fileprivate var hasSongControls: Bool = false
    fileprivate var playerView: SongPlayerView!
    fileprivate var playerViewTopConstraint: NSLayoutConstraint!
    fileprivate let playerViewOffset: CGFloat = -110

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func load() {
        delegate = self
        
        // Add song player view if needed
        guard playerView == nil else { return }
        guard let frame = selectedViewController?.view.frame else { return }
        playerView = SongPlayerView(frame: frame)
        playerView.delegate = self
        AudioPlayer.shared.songPlayerViewDelegate = self
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        playerViewTopConstraint = playerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: playerViewOffset)
        playerViewTopConstraint.isActive = true
        playerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: frame.height - tabBar.frame.height).isActive = true
      view.bringSubviewToFront(tabBar)
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
        // Reset SongsVC detail title if not transitioning with goToSongs()
        if let songsVC = viewController as? SongsViewController {
            songsVC.detailTitleLabel.text = ""
            songsVC.isPaging = true
            songsVC.fetchSongs()
        }
    }

}

extension TabBarController: SongPlayerViewDelegate {
    func updateUpcomingSongs() {
        DispatchQueue.main.async {
            self.playerView.songQueueTableView.reloadData()
        }
    }
    
    func updateSong(_ s: Song) {
        playerView.song = s
    }
    
    func updatePlayState(_ s: PlayState) {
        playerView.playState = s
    }
    
    func didTapToolBar() {
        guard let _ = selectedViewController as? ContainerDelegate else { return }

        // Toggle the panel state
        // Open
        if playerView.isCollapsed {
            openPlayerView()
        } else {
            // Close
            closePlayerView()
        }
    }
    
    func didPanToolBar(sender: UIPanGestureRecognizer) {
        guard let _ = selectedViewController as? ContainerDelegate else { return }
        
        let yLocation = sender.location(in: selectedViewController!.view).y
        let gestureState = sender.state
        
        // Animate the panel motion
        playerViewTopConstraint.constant = playerViewOffset + yLocation - playerView.frame.height
        playerView.updateConstraintsIfNeeded()
        playerView.layoutIfNeeded()
        view.layoutIfNeeded()
        playerView.layoutIfNeeded()
        
        if gestureState == .ended {
            if abs(playerViewTopConstraint.constant) > playerView.frame.height / 2 {
                openPlayerView()
            } else {
                closePlayerView()
            }
        }
    }
    
    func openPlayerView() {
        playerViewTopConstraint.constant = -view.frame.height + 20 // hack toolbar offset?
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut, animations: {
            self.playerView.updateConstraintsIfNeeded()
            self.playerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.playerView.layoutIfNeeded()
            self.playerView.isCollapsed = false
        })
    }
    
    func closePlayerView() {
        playerViewTopConstraint.constant = playerViewOffset
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut, animations: {
            self.playerView.updateConstraintsIfNeeded()
            self.playerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.playerView.layoutIfNeeded()
            self.playerView.isCollapsed = true
        })
    }
    
}
