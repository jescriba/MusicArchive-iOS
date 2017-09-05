//
//  SongsTablePlayerView.swift
//  MusicArchive
//
//  Created by Joshua on 9/3/17.
//  Copyright © 2017 Joshua. All rights reserved.
//

import Foundation
import UIKit

class SongsTablePlayerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!

    var songs = [Song]()
    var isPlaying: Bool = false {
        didSet {
            // TODO
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
        Bundle.main.loadNibNamed("SongsTablePlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        // Set tableview properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")

        // Set initial footer state
        isPlaying = false

        // Fetch songs
        MusicAPIClient.fetchSongs(success: { songs in
            self.songs = songs
            self.tableView.reloadData()
        })
    }


}

extension SongsTablePlayerView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongsTableViewCell", for: indexPath) as! SongsTableViewCell
        cell.song = songs[indexPath.row]
        return cell
    }
}

extension SongsTablePlayerView: UITableViewDelegate {

}
