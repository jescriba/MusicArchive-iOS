//
//  SongsTablePlayerView.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class SongsTablePlayerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerPlayImageView: UIImageView!
    @IBOutlet weak var footerPreviousImageView: UIImageView!
    @IBOutlet weak var footerSongName: UILabel!
    @IBOutlet weak var footerNextImageView: UIImageView!

    var songs = [Song]()
    var isPlaying: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if (self.isPlaying) {
                    self.footerPlayImageView.image = #imageLiteral(resourceName: "pause")
                } else {
                    self.footerPlayImageView.image = #imageLiteral(resourceName: "play")
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadXib()
    }

    func loadXib() {
        Bundle.main.loadNibNamed("SongsTablePlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        // Set tableview properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")

        // Set initial footer state
        isPlaying = false
        
        // Fetch songs
        MusicAPIClient.fetchSongs(success: { songs in
            self.songs = songs
            self.tableView.reloadData()
        })
    }

    func reloadData() { tableView.reloadData() }

    @IBAction func tappedPlay(_ sender: UITapGestureRecognizer) {
        if (isPlaying) {
            AudioPlayer.shared.pause()
            isPlaying = false
        } else {
            AudioPlayer.shared.play()
            isPlaying = true
        }
    }

    @IBAction func tappedNext(_ sender: UITapGestureRecognizer) {
        // TODO
    }

    @IBAction func tappedPrevious(_ sender: UITapGestureRecognizer) {
        // TODO
    }

}

extension SongsTablePlayerView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongsTableViewCell", for: indexPath) as! SongsTableViewCell
        cell.song = songs[indexPath.row]

        // Set selected background view properties
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:1.00, green:0.66, blue:1.00, alpha:1.0)
        cell.selectedBackgroundView = bgView

        return cell
    }
}

extension SongsTablePlayerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SongsTableViewCell
        let song = cell.song
        footerSongName.text = song?.name ?? "-"

        // Ensure any existing audio player stops
        AudioPlayer.shared.stop()

        // Play audio - async since url -> data can take awhile
        // TODO loading indicators
        DispatchQueue.global(qos: .userInitiated).async {
            AudioPlayer.shared.url = song?.url
            AudioPlayer.shared.play()
            self.isPlaying = true
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
