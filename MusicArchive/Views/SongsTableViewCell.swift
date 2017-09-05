//
//  SongsTableViewCell.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class SongsTableViewCell: UITableViewCell {
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistsNameLabel: UILabel!
    @IBOutlet weak var recordedDateLabel: UILabel!
    @IBOutlet weak var playIconImageView: UIImageView!

    var song: Song? {
        didSet {
            guard let s = song else { return }
            songNameLabel.text = s.name
            recordedDateLabel.text = s.recordedDate?.toString() ?? "-"
            artistsNameLabel.text = s.artistNames()
        }

    }
    
}
