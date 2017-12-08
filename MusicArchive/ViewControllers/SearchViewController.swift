//
//  ViewController.swift
//  MusicArchive
//
//  Created by Joshua on 8/28/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var songTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        artistTextField.delegate = self
        songTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func search(_ sender: Any) {
        let tabController = tabBarController as! TabBarController
        tabController.goToSongs(search: ["song-name":songTextField.text ?? "", "artist-name":artistTextField.text ?? "", "recorded-start":startDatePicker.date.toSearchString(), "recorded-end":endDatePicker.date.toSearchString()])
    }

    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        artistTextField.endEditing(true)
        songTextField.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchViewController: ContainerDelegate {
    var containerView: UIView {
        get {
            return view
        }
    }
}
