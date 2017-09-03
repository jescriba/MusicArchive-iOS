//
//  File.swift
//  MusicArchive
//
//  Created by Joshua on 8/30/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class ArtistsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var artists = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self

        MusicAPIClient.fetchArtists(success: { artists in

        })
    }

}

extension ArtistsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistsTableViewCell", for: indexPath) as! ArtistsTableViewCell
        cell.artist = artists[indexPath.row]
        return cell
    }

}

extension ArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO Prepare SongsTableView based on Artist
    }
}

