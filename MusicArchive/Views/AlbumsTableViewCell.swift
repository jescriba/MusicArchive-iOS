//
//  AlbumsTableViewCell.swift
//  MusicArchive
//
//  Created by Joshua Escribano on 10/23/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AlbumsTableViewCell: UITableViewCell {
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var album: Album? {
        didSet {
            guard let val = album else { return }
            guard let name = val.name else { return }
            nameLabel.text = "\(name)"
            artistsLabel.text = val.artistsNames
        }
    }
}
