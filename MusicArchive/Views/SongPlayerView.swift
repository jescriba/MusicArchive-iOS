//
//  SongPlayerView.swift
//  MusicArchive
//
//  Created by Joshua Escribano on 10/27/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

enum PlayState {
    case playing, paused, stopped, loading
}

protocol SongPlayerViewDelegate {
    func updateSong(_ s: Song)
    func updatePlayState(_ s: PlayState)
}

class SongPlayerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var songControlName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songDescription: UILabel!
    @IBOutlet weak var artistNames: UILabel!
    @IBOutlet weak var recordedDate: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDescription: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var songQueueTableView: UITableView!
    var playState: PlayState = PlayState.stopped {
        didSet {
            switch self.playState {
            case .playing:
                if let _ = self.playButton.imageView?.isAnimating {
                    DispatchQueue.main.async {
                        self.playButton.imageView?.stopAnimating()
                    }
                }
                playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                break
            case .paused:
                fallthrough
            case .stopped:
                if let _  = self.playButton.imageView?.isAnimating {
                    DispatchQueue.main.async {
                        self.playButton.imageView?.stopAnimating()
                    }
                }
                playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                break
            case.loading:
                DispatchQueue.main.async {
                    self.playButton.imageView?.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
                    self.playButton.imageView?.animationDuration = 0.50
                    self.playButton.imageView?.startAnimating()
                }
                break
            }
        }
    }
    var song: Song? {
        didSet {
            guard let s = song else { return }
            
            // Fill out song details
            artistNames.text = s.artistNames()
            songControlName.text = s.name
            songName.text = s.name
            recordedDate.text = s.recordedDate?.toString()
            // Fill out album details TODO
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadXib()
    }
    
    func loadXib() {
        Bundle.main.loadNibNamed("SongPlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.shadowRadius = 1
        contentView.layer.shadowOpacity = 0.02
//
//        // Set tableview properties
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.tableFooterView = UIView()
//        tableView.showsVerticalScrollIndicator = false
//        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")
//
//        // Set AudioPlayerDelegate for playing next track
//        AudioPlayer.shared.delegate = self
//
        // Set initial footer state
        playState = .stopped
    }
    
    @IBAction func tappedPrevious(_ sender: Any) {
        //        playIndex = (playIndex - 1) % songs.count
        //        let newSong = songs[playIndex]
        //        let wasPlaying = playState
        //
        //        // Stop playing while loading next track
        //        AudioPlayer.shared.stop()
        //        footerSongName.text = newSong.name
        //
        //        // Start loading
        //        playState = .loading
        //        footerPlayImageView.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
        //        footerPlayImageView.startAnimating()
        //
        //        // Update UI/animations after setting URL and continue playing if it was
        //        AudioPlayer.shared.setUrl(newSong.url, success: {
        //            DispatchQueue.main.async {
        //                self.footerPlayImageView.stopAnimating()
        //                if (wasPlaying == .playing) {
        //                    self.playState = .playing
        //                    AudioPlayer.shared.play()
        //                } else {
        //                    self.playState = .stopped
        //                }
        //                self.footerPlayImageView.stopAnimating()
        //            }
        //        })
    }
    
    @IBAction func tappedPlay(_ sender: Any) {
        switch playState {
        case .playing:
            AudioPlayer.shared.pause()
            playState = .paused
            break
        case .loading:
            self.playButton.setImage(#imageLiteral(resourceName: "loading"), for: .normal)
            break
        case .paused:
            fallthrough
        case .stopped:
            // Prevent tapping during loading - otherwise play
            AudioPlayer.shared.play()
            playState = .playing
            break
        }
    }
    @IBAction func tappedNext(_ sender: Any) {
        // delega
        //        playIndex = (playIndex + 1) % songs.count
        //        let newSong = songs[playIndex]
        //        let wasPlaying = playState
    }
    
}
