// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation
import UIKit

class ArtistsTableViewCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!

  var artist: Artist? {
    didSet {
      guard let val = artist else { return }
      guard let name = val.name else { return }
      nameLabel.text = "\(name)"
    }
  }
}
