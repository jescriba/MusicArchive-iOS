// Copyright (c) 2019 Joshua Escribano-Fontanet

import AVFoundation
import Foundation
import UIKit

class SongsTableViewCell: UITableViewCell {
  @IBOutlet var songNameLabel: UILabel!
  @IBOutlet var artistsNameLabel: UILabel!
  @IBOutlet var recordedDateLabel: UILabel!
  @IBOutlet var playIconImageView: UIImageView!

  var song: Song? {
    didSet {
      guard let s = song else { return }
      songNameLabel.text = s.name
      recordedDateLabel.text = s.recordedDate?.toString() ?? "-"
      artistsNameLabel.text = s.artistNames()
    }
  }
}
