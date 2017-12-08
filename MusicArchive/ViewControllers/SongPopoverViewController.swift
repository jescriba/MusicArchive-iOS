//
//  SongPopoverViewController.swift
//  MusicArchive
//
//  Created by Joshua Escribano on 9/30/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

enum SongPopoverAction {
    case playNext, playLater, favorite, share
}

protocol SongPopoverDelegate {
    func showPopover(song: Song, cell: SongsTableViewCell)
    func didPerformAction(songPopoverAction: SongPopoverAction, song: Song)
}

class SongPopoverViewController: UIViewController {
    var delegate: SongPopoverDelegate?
    var song: Song = Song([String:String]())
    
    @IBAction func playNext(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .playNext, song: song) }
    
    @IBAction func playLater(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .playLater, song: song) }
    
    @IBAction func favorite(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .favorite, song: song) }
    
    @IBAction func share(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .share, song: song) }
}
