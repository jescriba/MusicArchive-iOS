//
//  AudioPlayer.swift
//  MusicArchive
//
//  Created by Joshua on 9/6/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import AVFoundation

// Note: My original approach was to use AVAudioEngine so I could do
// nicer things like track fading and fx - but I'd likely have to download the file
// if I wanted to use AVAudioPlayerNode - see: https://stackoverflow.com/questions/30862664/stream-data-from-network-in-avaudioengine-is-it-possible
class AudioPlayer: NSObject {
    static let shared = AudioPlayer()
    var songPlayerViewDelegate: SongPlayerViewDelegate?
    private var player: AVAudioPlayer? {
        didSet {
            guard let p = player else { return }
            p.numberOfLoops = 0
            p.delegate = self
        }
    }
    // Short queue to prevent loading songs up front
    private var dataQueue = [Data]() {
        didSet {
            // Grab the first data and update the player
            do {
                let data = dataQueue.first!
                player = try AVAudioPlayer(data: data)
                DispatchQueue.main.async {
                    self.songPlayerViewDelegate?.updatePlayState(.stopped)
                }
                
            } catch {
                print("failed loading avaudioplayer")
            }
        }
    }
    
    private var songQueue = [Song]() {
        didSet {
            if oldValue.first?.id != songQueue.first?.id && oldValue.count > songQueue.count {
                // Removing/dequeuing
                if dataQueue.count < 3 {
                    //            do {
                    //                let data = try Data(contentsOf: u)
                    //                player = try AVAudioPlayer(data: data)
                    //            } catch {
                    //                print("Failed loading AVAudioPlayer")
                    //            }
                }
            } else if oldValue.first?.id != songQueue.first?.id && oldValue.count < songQueue.count {
                // PLAY NOW: by inserting to front of queue
                guard let u = songQueue.first?.url else { return }
                
                // Insert data to front of queue
                songPlayerViewDelegate?.updatePlayState(.loading)
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let data = try Data(contentsOf: u)
                        self.dataQueue.insert(data, at: 0)
                    } catch { print("Failed loading dataQueue") }
                }
            } else {
                // Enqueuing
            }
        }
    }
    
    func playNow(_ song: Song) {
        guard let _ = song.url else { return }
        songQueue.insert(song, at: 0)
    }
    
    func playNext(_ song: Song) {
        guard let _ = song.url else { return }
        songQueue.insert(song, at: 1)
    }
    
    func playLater(_ song: Song) {
        guard let _ = song.url else { return }
        songQueue.append(song)
    }
    
    override init() {
        super.init()
        
        // Enable audio when side clicker is set to mute
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch  { print("audio session crash") }
    }

    func play() {
        player?.play()
        songPlayerViewDelegate?.updatePlayState(.playing)
    }
    func pause() {
        player?.pause()
        songPlayerViewDelegate?.updatePlayState(.paused)
    }
    func stop() {
        player?.stop()
        songPlayerViewDelegate?.updatePlayState(.stopped)
    }

}

extension AudioPlayer: AVAudioPlayerDelegate {
    // TODO - This could be expanded to handle audio interruptions more gracefully
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        songQueue.remove(at: 0)
    }
}
