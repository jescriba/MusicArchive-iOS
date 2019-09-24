// Copyright (c) 2019 Joshua Escribano-Fontanet

import AVFoundation
import Foundation

// Note: My original approach was to use AVAudioEngine so I could do
// nicer things like track fading and fx - but I'd likely have to download the file
// if I wanted to use AVAudioPlayerNode - see: https://stackoverflow.com/questions/30862664/stream-data-from-network-in-avaudioengine-is-it-possible
class AudioPlayer: NSObject {
  static let shared = AudioPlayer()
  var songPlayerViewDelegate: SongPlayerViewDelegate?
  private var queuePlayer = AVQueuePlayer()
  private var previousSongQueue = [Song]()
  private var songQueue = [Song]() {
    didSet {
      songPlayerViewDelegate?.updateUpcomingSongs()
    }
  }

  var upcomingSongs: [Song] {
    return Array(songQueue.dropFirst())
  }

  func playNow(_ song: Song) {
    guard let _ = song.url else { return }
    guard let asset = song.asset else { return }
    let playerItem = AVPlayerItem(asset: asset)
    queuePlayer.insert(playerItem, after: queuePlayer.items().last)
    if queuePlayer.items().count > 1 {
      queuePlayer.advanceToNextItem()
    }
    songQueue.insert(song, at: 0)
  }

  func playNext(_ song: Song) {
    guard let _ = song.url else { return }
    guard let asset = song.asset else { return }
    guard songQueue.count > 1 else { playNow(song)
      return
    }
    let playerItem = AVPlayerItem(asset: asset)
    queuePlayer.insert(playerItem, after: queuePlayer.items().first)
    songQueue.insert(song, at: 1)
  }

  func playLater(_ song: Song) {
    guard let _ = song.url else { return }
    guard let asset = song.asset else { return }
    let playerItem = AVPlayerItem(asset: asset)
    queuePlayer.insert(playerItem, after: nil)
    songQueue.append(song)
  }

  func skipToNext() {
    if songQueue.count < 2 { return }
    queuePlayer.advanceToNextItem()
    songQueue.removeFirst()
    let s = songQueue.first!
    songPlayerViewDelegate?.updateSong(s)
  }

  func skipToPrevious() {
    // TODO: Check if song has been playing for awhile then just restart it
    // Else play previous song that was playing
    guard let s = previousSongQueue.first else { return }
    playNow(s)
  }

  override init() {
    super.init()

    // Enable audio when side clicker is set to mute
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setActive(true)
      try audioSession.setCategory(AVAudioSession.Category.playback)
    } catch { print("audio session crash") }
  }

  func play() {
    queuePlayer.play()
    songPlayerViewDelegate?.updatePlayState(.playing)
  }

  func pause() {
    queuePlayer.pause()
    songPlayerViewDelegate?.updatePlayState(.paused)
  }

  func stop() {
    queuePlayer.pause()
    let startTime = CMTime(seconds: 0, preferredTimescale: CMTimeScale(1))
    queuePlayer.seek(to: startTime)
    songPlayerViewDelegate?.updatePlayState(.stopped)
  }
}
