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

    override func viewDidLoad() {
        super.viewDidLoad()

        MusicAPIClient.fetchSongs(success: { songs in
            self.songs = songs
            self.songsTablePlayerView.songs = self.songs
        })
    }
}
