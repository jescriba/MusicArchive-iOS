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
    private var player: AVAudioPlayer? {
        didSet {
            guard let p = player else { return }

            p.numberOfLoops = 0
            p.delegate = self
        }
    }
    var url: URL? {
        didSet {
            guard let u = url else { return }

            do {
                let data = try Data(contentsOf: u)
                player = try AVAudioPlayer(data: data)
            } catch {
                print("Failed loading AVAudioPlayer")
            }
        }
    }

    func play() { player?.play() }
    func pause() { player?.pause() }
    func stop() { player?.stop() }

}

extension AudioPlayer: AVAudioPlayerDelegate {
    // TODO
}