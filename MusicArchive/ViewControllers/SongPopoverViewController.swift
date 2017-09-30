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
    func didPerformAction(songPopoverAction: SongPopoverAction, songId: Int)
}

class SongPopoverViewController: UIViewController {
    var delegate: SongPopoverDelegate?
    var songId: Int = 0
    
    @IBAction func playNext(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .playNext, songId: songId) }
    
    @IBAction func playLater(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .playLater, songId: songId) }
    
    @IBAction func favorite(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .favorite, songId: songId) }
    
    @IBAction func share(_ sender: Any) { delegate?.didPerformAction(songPopoverAction: .share, songId: songId) }
}
