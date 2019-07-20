// Copyright (c) 2019 Joshua Escribano-Fontanet

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var artistTextField: UITextField!
    @IBOutlet var songTextField: UITextField!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var searchButton: UIButton!

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

    @IBAction func search(_: Any) {
        let tabController = tabBarController as! TabBarController
        tabController.goToSongs(search: ["song-name": songTextField.text ?? "", "artist-name": artistTextField.text ?? "", "recorded-start": startDatePicker.date.toSearchString(), "recorded-end": endDatePicker.date.toSearchString()])
    }

    @IBAction func viewTapped(_: UITapGestureRecognizer) {
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
        return view
    }
}
