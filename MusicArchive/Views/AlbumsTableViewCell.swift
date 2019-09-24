// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation
import UIKit

class AlbumsTableViewCell: UITableViewCell {
  @IBOutlet var artistsLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!

  var album: Album? {
    didSet {
      guard let val = album else { return }
      guard let name = val.name else { return }
      nameLabel.text = "\(name)"
      artistsLabel.text = val.artistsNames
    }
  }
}
