//
//  SongsTablePlayerView.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

enum PlayState {
    case playing, paused, stopped, loading
}

class SongsTablePlayerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerPlayImageView: UIImageView!
    @IBOutlet weak var footerPreviousImageView: UIImageView!
    @IBOutlet weak var footerSongName: UILabel!
    @IBOutlet weak var footerNextImageView: UIImageView!
    var delegate: SongPopoverDelegate?
    var playIndex = 0
    var lastFetchSize = 1
    var page = 1 {
        didSet { if (page == 1) { lastFetchSize = 1 } }
    }
    var artist: Artist?
    var album: Album?
    var songs = [Song]()
    var playState: PlayState = PlayState.stopped {
        didSet {
            switch self.playState {
                case .playing:
                    footerPlayImageView.image = #imageLiteral(resourceName: "pause")
                    break
                case .paused:
                    footerPlayImageView.image = #imageLiteral(resourceName: "play")
                    break
                case .stopped:
                    footerPlayImageView.image = #imageLiteral(resourceName: "play")
                    break
                case.loading:
                    break
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
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")
        
        // Set AudioPlayerDelegate for playing next track
        AudioPlayer.shared.delegate = self

        // Set initial footer state
        playState = .stopped
        
        // Fetch songs
        MusicAPIClient.fetchSongs(success: { songs in
            self.songs = songs
            self.tableView.reloadData()
        })
    }

    func reloadData() { tableView.reloadData() }

    @IBAction func tappedPlay(_ sender: UITapGestureRecognizer) {
        if (playState == .playing) {
            AudioPlayer.shared.pause()
            playState = .paused
        } else if (playState != .loading) {
            // Prevent tapping during loading - otherwise play
            AudioPlayer.shared.play()
            playState = .playing
        }
    }

    @IBAction func tappedNext(_ sender: UITapGestureRecognizer) {
        playIndex = (playIndex + 1) % songs.count
        let newSong = songs[playIndex]
        let wasPlaying = playState
        
        // Stop playing while loading next track
        AudioPlayer.shared.stop()
        footerSongName.text = newSong.name
        
        // Start loading
        playState = .loading
        footerPlayImageView.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
        footerPlayImageView.animationDuration = 0.5
        footerPlayImageView.startAnimating()
        
        // Update UI/animations after setting URL and continue playing if it was
        // TODO refactor this success closure
        AudioPlayer.shared.setUrl(newSong.url, success: {
            DispatchQueue.main.async {
                self.footerPlayImageView.stopAnimating()
                if (wasPlaying == .playing) {
                    self.playState = .playing
                    AudioPlayer.shared.play()
                } else {
                    self.playState = .stopped
                }
                self.footerPlayImageView.stopAnimating()
            }
        })
    }

    @IBAction func tappedPrevious(_ sender: UITapGestureRecognizer) {
        playIndex = (playIndex - 1) % songs.count
        let newSong = songs[playIndex]
        let wasPlaying = playState
        
        // Stop playing while loading next track
        AudioPlayer.shared.stop()
        footerSongName.text = newSong.name
        
        // Start loading
        playState = .loading
        footerPlayImageView.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
        footerPlayImageView.startAnimating()
        
        // Update UI/animations after setting URL and continue playing if it was
        AudioPlayer.shared.setUrl(newSong.url, success: {
            DispatchQueue.main.async {
                self.footerPlayImageView.stopAnimating()
                if (wasPlaying == .playing) {
                    self.playState = .playing
                    AudioPlayer.shared.play()
                } else {
                    self.playState = .stopped
                }
                self.footerPlayImageView.stopAnimating()
            }
        })
    }
    
    @objc func didLongPressOnCell(sender: UILongPressGestureRecognizer) {
        guard let cell = sender.view as? SongsTableViewCell else { return }
        guard let song = cell.song else { return }
        
        delegate?.showPopover(song: song, cell: cell)
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
        
        // Setup long press behavior
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnCell))
        cell.addGestureRecognizer(recognizer)

        return cell
    }
}

extension SongsTablePlayerView: AudioPlayerDelegate {
    func completedTrack() {
        // Fake a tap for now - likely not best practice and may want to refactor
        tappedNext(UITapGestureRecognizer())
    }
}

extension SongsTablePlayerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SongsTableViewCell
        let song = cell.song
        footerSongName.text = song?.name ?? "-"
        
        // Update playIndex for next/previous tracking
        playIndex = indexPath.row

        // Ensure any existing audio player stops
        AudioPlayer.shared.stop()

        // Play audio - async since url -> data can take awhile
        // TODO loading indicators
        AudioPlayer.shared.setUrl(song?.url, success: {
            AudioPlayer.shared.play()
            DispatchQueue.main.async { self.playState = .playing }
        })

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < 0) {
            // TODO refresh
        }
        
        // Check if scrolled to bottom to refresh/update page
        if (scrollView.contentSize.height <= scrollView.frame.height + scrollView.contentOffset.y) {
            page += 1
            
            if lastFetchSize > 0 {
                // Fetch songs for page
                let successClosure = { (songs: [Song]) in
                    self.lastFetchSize = songs.count
                    self.songs += songs
                    self.tableView.reloadData()
                }
                if let a = artist , let id = a.id {
                    MusicAPIClient.fetchSongsByArtistId(id,
                                                        params: ["page":page],
                                                        success: successClosure)
                } else if let a = album, let id = a.id {
                    MusicAPIClient.fetchSongsByAlbumId(id,
                                                        params: ["page":page],
                                                        success: successClosure)
                } else {
                    MusicAPIClient.fetchSongs(params: ["page":page],
                                              success: successClosure)
                }
            }
        }
    }
}
