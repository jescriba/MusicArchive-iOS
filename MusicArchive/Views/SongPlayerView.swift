// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation
import UIKit

enum PlayState {
  case playing, paused, stopped, loading
}

protocol SongPlayerViewDelegate {
  func updateSong(_ s: Song)
  func updatePlayState(_ s: PlayState)
  func didTapToolBar()
  func didPanToolBar(sender: UIPanGestureRecognizer)
  func updateUpcomingSongs()
}

class SongPlayerView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet var playButton: UIButton!
  @IBOutlet var nextButton: UIButton!
  @IBOutlet var previousButton: UIButton!
  @IBOutlet var songControlName: UILabel!
  @IBOutlet var songName: UILabel!
  @IBOutlet var songDescription: UILabel!
  @IBOutlet var artistNames: UILabel!
  @IBOutlet var recordedDate: UILabel!
  @IBOutlet var albumName: UILabel!
  @IBOutlet var albumDescription: UILabel!
  @IBOutlet var releaseDate: UILabel!
  @IBOutlet var songQueueTableView: UITableView!
  var isCollapsed = true
  var delegate: SongPlayerViewDelegate?
  var playState: PlayState = PlayState.stopped {
    didSet {
      switch playState {
      case .playing:
        if let _ = self.playButton.imageView?.isAnimating {
          DispatchQueue.main.async {
            self.playButton.imageView?.stopAnimating()
          }
        }
        playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
      case .paused:
        fallthrough
      case .stopped:
        if let _ = self.playButton.imageView?.isAnimating {
          DispatchQueue.main.async {
            self.playButton.imageView?.stopAnimating()
          }
        }
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
      case .loading:
        DispatchQueue.main.async {
          self.playButton.imageView?.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
          self.playButton.imageView?.animationDuration = 0.50
          self.playButton.imageView?.startAnimating()
        }
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
      songDescription.text = s.description
      // Fill out album details TODO
      albumName.text = s.album?.name
      albumDescription.text = ""
      releaseDate.text = ""
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
    contentView.frame = bounds
    contentView.layer.shadowRadius = 1
    contentView.layer.shadowOpacity = 0.02

    // Set tableview properties
    songQueueTableView.delegate = self
    songQueueTableView.dataSource = self
    songQueueTableView.tableFooterView = UIView()
    songQueueTableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")

    // Set initial footer state
    playState = .stopped
  }

  @IBAction func tappedPrevious(_: Any) {
    AudioPlayer.shared.skipToPrevious()
  }

  @IBAction func tappedPlay(_: Any) {
    switch playState {
    case .playing:
      AudioPlayer.shared.pause()
      playState = .paused
    case .loading:
      playButton.setImage(#imageLiteral(resourceName: "loading"), for: .normal)
    case .paused:
      fallthrough
    case .stopped:
      // Prevent tapping during loading - otherwise play
      AudioPlayer.shared.play()
      playState = .playing
    }
  }

  @IBAction func tappedNext(_: Any) {
    AudioPlayer.shared.skipToNext()
  }

  @IBAction func didTapOnToolBar(_: UITapGestureRecognizer) {
    delegate?.didTapToolBar()
  }

  @IBAction func didPanOnToolBar(_ sender: UIPanGestureRecognizer) {
    delegate?.didPanToolBar(sender: sender)
  }
}

extension SongPlayerView: UITableViewDelegate {}

extension SongPlayerView: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return AudioPlayer.shared.upcomingSongs.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SongsTableViewCell") as! SongsTableViewCell
    cell.song = AudioPlayer.shared.upcomingSongs[indexPath.row]
    return cell
  }
}
