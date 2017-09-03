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
    var artist: Artist? {
        didSet {
            guard let val = artist else { return }
            //val.name
        }
    }
    
}
