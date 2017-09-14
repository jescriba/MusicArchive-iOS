//
//  HomeView.swift
//  MusicArchive
//
//  Created by Joshua Escribano on 9/9/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class HomeView: UIView {
    @IBOutlet var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadXib()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadXib()
    }
    
    func loadXib() {
        Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

    }
}
