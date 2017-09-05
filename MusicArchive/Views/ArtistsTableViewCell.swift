//
//  ArtistsTableViewCell.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class ArtistsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!

    var artist: Artist? {
        didSet {
            guard let val = artist else { return }
            guard let name = val.name else { return }
            nameLabel.text = "\(name)"
        }
    }
    
}
