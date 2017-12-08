//
//  HomeViewController.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var baseView: HomeView!
    
}

extension HomeViewController: ContainerDelegate {
    var containerView: UIView {
        get {
            return baseView
        }
    }
}
