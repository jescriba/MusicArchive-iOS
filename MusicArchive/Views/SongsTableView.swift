// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation
import UIKit

class SongsTableView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!
    var delegate: SongPopoverDelegate?
    var songPlayerViewDelegate: SongPlayerViewDelegate?
    var isPaging = true
    var lastFetchSize = 1
    var page = 1 {
        didSet { if page == 1 { lastFetchSize = 1 } }
    }

    var artist: Artist?
    var album: Album?
    var songs = [Song]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadXib()
    }

    func loadXib() {
        Bundle.main.loadNibNamed("SongsTableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds

        // Set tableview properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SongsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SongsTableViewCell")
    }

    func reloadData() { tableView.reloadData() }

    @objc func didLongPressOnCell(sender: UILongPressGestureRecognizer) {
        guard let cell = sender.view as? SongsTableViewCell else { return }
        guard let song = cell.song else { return }

        delegate?.showPopover(song: song, cell: cell)
    }
}

extension SongsTableView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongsTableViewCell", for: indexPath) as! SongsTableViewCell
        cell.song = songs[indexPath.row]

        // Set selected background view properties
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red: 1.00, green: 0.66, blue: 1.00, alpha: 1.0)
        cell.selectedBackgroundView = bgView

        // Setup long press behavior
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnCell))
        cell.addGestureRecognizer(recognizer)

        return cell
    }
}

extension SongsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SongsTableViewCell
        let song = cell.song
        guard let s = song else { return }

        songPlayerViewDelegate?.updateSong(s)
        DispatchQueue.global().async {
            AudioPlayer.shared.playNow(s)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            // TODO: refresh
        }

        guard isPaging else { return }

        // Check if scrolled to bottom to refresh/update page
        if scrollView.contentSize.height <= scrollView.frame.height + scrollView.contentOffset.y {
            page += 1

            if lastFetchSize > 0 {
                // Fetch songs for page
                let successClosure = { (songs: [Song]) in
                    self.lastFetchSize = songs.count
                    self.songs += songs
                    self.tableView.reloadData()
                }
                if let a = artist, let id = a.id {
                    MusicAPIClient.fetchSongsByArtistId(id,
                                                        params: ["page": page],
                                                        success: successClosure)
                } else if let a = album, let id = a.id {
                    MusicAPIClient.fetchSongsByAlbumId(id,
                                                       params: ["page": page],
                                                       success: successClosure)
                } else {
                    MusicAPIClient.fetchSongs(params: ["page": page],
                                              success: successClosure)
                }
            }
        }
    }
}
