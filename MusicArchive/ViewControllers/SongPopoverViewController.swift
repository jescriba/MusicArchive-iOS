// Copyright (c) 2019 Joshua Escribano-Fontanet

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
  var song: Song = Song([String: String]())

  @IBAction func playNext(_: Any) { delegate?.didPerformAction(songPopoverAction: .playNext, song: song) }

  @IBAction func playLater(_: Any) { delegate?.didPerformAction(songPopoverAction: .playLater, song: song) }

  @IBAction func favorite(_: Any) { delegate?.didPerformAction(songPopoverAction: .favorite, song: song) }

  @IBAction func share(_: Any) { delegate?.didPerformAction(songPopoverAction: .share, song: song) }
}
