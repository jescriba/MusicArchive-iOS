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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sourceModalView: UIView!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var sourceUrl = Endpoints.baseEndPoint {
        didSet {
            // Update endpoint if sourceUrl changed
            Endpoints.baseEndPoint = sourceUrl
            // Update UI
            sourceNameLabel.text = sourceUrl.titleFromUrl()
        }
    }
    
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
        
        // Set up text field behavior
        sourceTextField.delegate = self
        // Set source name label
        sourceNameLabel.adjustsFontSizeToFitWidth = true
        sourceNameLabel.text = Endpoints.baseEndPoint.titleFromUrl()
        
        // Set up tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")
    }
    
    @IBAction func sourceTapped(_ sender: Any) {
        blurView.frame = superview?.frame ?? contentView.frame
        superview?.addSubview(blurView)
        sourceModalView.frame = CGRect(x: contentView.frame.midX - 220 / 2, y: 50, width: 220, height: 100)
        sourceModalView.layer.cornerRadius = 5
        blurView.contentView.addSubview(sourceModalView)
        
        // Trigger keyboard
        sourceTextField.placeholder = sourceUrl
        sourceTextField.becomeFirstResponder()
    }
    
    @objc func sourceDismissed() {
        blurView.removeFromSuperview()
    }
}

extension HomeView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Update endpoint
        if let url = sourceTextField.text?.asValidUrl() {
            sourceUrl = url
        }
    
        // Dismiss keyboard
        textField.endEditing(true)
        sourceDismissed()
        return true
    }

}

extension HomeView: UITableViewDelegate {
    // TODO
}

extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongsTableViewCell", for: indexPath) as! SongsTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

}
