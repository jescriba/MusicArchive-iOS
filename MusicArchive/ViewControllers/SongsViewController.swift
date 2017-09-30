//
//  SongsViewController.swift
//  MusicArchive
//
//  Created by Joshua on 8/28/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class SongsViewController: UIViewController {
    @IBOutlet weak var songsTablePlayerView: SongsTablePlayerView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    var loadingImageView = UIImageView(image: #imageLiteral(resourceName: "loading"))
    var songs = [Song]()
    var artist: Artist? = nil {
        didSet {
            loadViewIfNeeded() // Avoid nil SongsTablePlayerView
            
            songsTablePlayerView.artist = artist
            if let name = artist?.name {
                detailTitleLabel.text = name
            } else {
                detailTitleLabel.text = ""
            }
            fetchSongs(success: { songs in
                self.songs = songs
                self.songsTablePlayerView.songs = self.songs
                self.songsTablePlayerView.reloadData()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoadingAnimation()
        fetchSongs()
        
        // Setup SongsVC to handle popover presentation
        songsTablePlayerView.delegate = self
    }
    
    // Update UI for loading indicators
    func startLoadingAnimation() {
        loadingImageView.frame = CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25, width: 50, height: 50)
        loadingImageView.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
        loadingImageView.animationDuration = 0.4
        loadingImageView.startAnimating()
        view.addSubview(loadingImageView)
    }
    
    func stopLoadingAnimation() {
        loadingImageView.stopAnimating()
        loadingImageView.removeFromSuperview()
    }
    
    // Network calls to load songs
    func searchSongs(_ params: [String:Any]) {
        MusicAPIClient.searchSongs(params, success: { songs in
            self.songs = songs
            self.songsTablePlayerView.songs = songs
            self.songsTablePlayerView.reloadData()
            // Ensure initial loading animation is removed
            self.stopLoadingAnimation()
        })
    }
    
    func fetchSongs() {
        fetchSongs(success: { songs in
            self.songs = songs
            self.songsTablePlayerView.songs = self.songs
            self.songsTablePlayerView.reloadData()
            // Ensure initial loading animation is removed
            self.stopLoadingAnimation()
        })
    }

    private func fetchSongs(success: @escaping ([Song]) -> (), failure: ((Error?) -> ())? = nil) {
        if let artistId = artist?.id {
            MusicAPIClient.fetchSongsByArtistId(artistId, params: ["page":songsTablePlayerView.page], success: success, failure: failure)
        } else {
            MusicAPIClient.fetchSongs(params: ["page": songsTablePlayerView.page], success: success, failure: failure)
        }
    }
}

extension SongsViewController: SongPopoverDelegate {
    func showPopover(song: Song, cell: SongsTableViewCell) {
        // Create and edit Popover VC
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SongActionPopover") as! SongPopoverViewController
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 150, height: 150)
        
        // Set delegate to handle popover actions
        vc.delegate = self

        // Prepare Popover Presentation
        let presentationController = vc.popoverPresentationController
        presentationController?.delegate = self
        presentationController?.sourceView = cell
        presentationController?.sourceRect = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        
        present(vc, animated: true, completion: nil)
    }
    
    func didPerformAction(songPopoverAction: SongPopoverAction) {
        switch songPopoverAction {
        case .playNext:
            break
        case .playLater:
            break
        case .favorite:
            break
        case .share:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension SongsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
