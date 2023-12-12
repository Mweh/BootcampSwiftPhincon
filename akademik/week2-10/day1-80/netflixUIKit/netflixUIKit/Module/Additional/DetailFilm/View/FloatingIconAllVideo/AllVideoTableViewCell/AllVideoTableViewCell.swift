//
//  AllVideoTableViewCell.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 04/12/23.
//

import UIKit
import youtube_ios_player_helper

class AllVideoTableViewCell: UITableViewCell, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var ytView: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ytView.webView?.allowsBackForwardNavigationGestures = true
        ytView.webView?.uiDelegate = self
        ytView.webView?.allowsLinkPreview = true
        ytView.webView?.navigationDelegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
