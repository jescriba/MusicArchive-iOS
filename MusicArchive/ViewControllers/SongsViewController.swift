// Copyright (c) 2019 Joshua Escribano-Fontanet

import Foundation
import UIKit

class SongsViewController: UIViewController {
    @IBOutlet var songsTableView: SongsTableView!
    @IBOutlet var detailTitleLabel: UILabel!
    var loadingImageView = UIImageView(image: #imageLiteral(resourceName: "loading"))
    var isPaging = true {
        didSet {
            loadViewIfNeeded()
            songsTableView.page = 1
            songsTableView.isPaging = isPaging
        }
    }

    var detailTitle: String? {
        didSet {
            loadViewIfNeeded()
            detailTitleLabel.text = detailTitle
        }
    }

    var songs = [Song]() {
        didSet {
            songsTableView.songs = songs
            songsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup SongsVC to handle popover presentation
        songsTableView.delegate = self
        songsTableView.songPlayerViewDelegate = parent as? TabBarController
    }

    // Update UI for loading indicators
    func startLoadingAnimation() {
        // Empty existing table
        songsTableView.songs = []
        songsTableView.reloadData()
        // Add center loading animation
        loadingImageView.frame = CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25, width: 50, height: 50)
        loadingImageView.animationImages = [#imageLiteral(resourceName: "loading"), #imageLiteral(resourceName: "loading-1"), #imageLiteral(resourceName: "loading-2"), #imageLiteral(resourceName: "loading-3")]
        loadingImageView.animationDuration = 0.4
        loadingImageView.startAnimating()
        view.addSubview(loadingImageView)
    }

    func stopLoadingAnimation() {
        loadingImageView.stopAnimating()
        loadingImageView.removeFromSuperview()
    }

    // Network calls to load songs
    func searchSongs(_ params: [String: Any]) {
        startLoadingAnimation()
        MusicAPIClient.searchSongs(params, success: { songs in
            self.songs = songs
            self.songsTableView.songs = songs
            self.songsTableView.reloadData()
            // Ensure initial loading animation is removed
            self.stopLoadingAnimation()
        })
    }

    func fetchSongs(artist: Artist? = nil, success successOptional: (([Song]) -> Void)? = nil, failure: ((Error?) -> Void)? = nil) {
        // Get non-optional success block
        var success: (([Song]) -> Void)!
        if let s = successOptional {
            success = s
        } else {
            success = { (songs: [Song]) in
                self.songs = songs
                self.songsTableView.songs = self.songs
                self.songsTableView.reloadData()
                // Ensure initial loading animation is removed
                self.stopLoadingAnimation()
            }
        }
        // Fetch songs, based on artist ID or not, with API Client
        startLoadingAnimation()
        if let artistId = artist?.id {
            MusicAPIClient.fetchSongsByArtistId(artistId, params: ["page": songsTableView.page], success: success, failure: failure)
        } else {
            MusicAPIClient.fetchSongs(params: ["page": songsTableView.page], success: success, failure: failure)
        }
    }
}

extension SongsViewController: SongPopoverDelegate {
    var songPlayerViewDelegate: SongPlayerViewDelegate? {
        return parent as? TabBarController
    }

    func showPopover(song: Song, cell: SongsTableViewCell) {
        // Create and edit Popover VC
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SongActionPopover") as! SongPopoverViewController
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 150, height: 150)
        vc.song = song

        // Set delegate to handle popover actions
        vc.delegate = self

        // Prepare Popover Presentation
        let presentationController = vc.popoverPresentationController
        presentationController?.delegate = self
        presentationController?.sourceView = cell
        presentationController?.sourceRect = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)

        present(vc, animated: true, completion: nil)
    }

    func didPerformAction(songPopoverAction: SongPopoverAction, song: Song) {
        dismiss(animated: true, completion: nil)

        switch songPopoverAction {
        case .playNext:
            AudioPlayer.shared.playNext(song)
        case .playLater:
            AudioPlayer.shared.playLater(song)
        case .favorite:
            break
        case .share:
            if let id = song.id {
                let vc = UIActivityViewController(activityItems: ["Check out this song", URL(string: "\(Endpoints.songsEndPoint)/\(id)")!], applicationActivities: nil)
                present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension SongsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for _: UIPresentationController, traitCollection _: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension SongsViewController: ContainerDelegate {
    var containerView: UIView {
        return view
    }
}
