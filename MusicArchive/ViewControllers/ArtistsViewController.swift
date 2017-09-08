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
        tableView.rowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self

        MusicAPIClient.fetchArtists(success: { artists in
            self.artists = artists
            self.tableView.reloadData()
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

        // Set selected background view properties
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:1.00, green:0.66, blue:1.00, alpha:1.0)
        cell.selectedBackgroundView = bgView
        
        return cell
    }

}

extension ArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ArtistsTableViewCell
        let artist = cell.artist

        // Go to songs page with songs filtered by artist
        let controller = tabBarController as? TabBarController
        controller?.goToSongs(artist: artist)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

