// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var baseView: HomeView!
}

extension HomeViewController: ContainerDelegate {
    var containerView: UIView {
        return baseView
    }
}
