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
    var songs = [Song]()
    var artist: Artist? {
        didSet {
            fetchSongs(success: { songs in
                self.songs = songs
                self.songsTablePlayerView.songs = self.songs
                self.songsTablePlayerView.reloadData()
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchSongs(success: { songs in
            self.songs = songs
            self.songsTablePlayerView.songs = self.songs
            self.songsTablePlayerView.reloadData()
        })
    }

    func fetchSongs(success: @escaping ([Song]) -> (), failure: ((Error?) -> ())? = nil) {
        if let artistId = artist?.id {
            MusicAPIClient.fetchSongs(artistId: artistId, success: success, failure: failure)
        } else {
            MusicAPIClient.fetchSongs(success: success, failure: failure)
        }
    }
}
