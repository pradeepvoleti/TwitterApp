//
//  TweetView.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import UIKit

typealias ShareBlock = (UIButton) -> Void

class TweetView: UIView {

    @IBOutlet var baseView: UIView!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userIdAndDuration: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var baseImageStack: UIStackView!
    @IBOutlet weak var leftImageStack: UIStackView!
    @IBOutlet weak var rightImageStack: UIStackView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet var image3Height: NSLayoutConstraint!
    @IBOutlet var baseImageStackHeight: NSLayoutConstraint!
    @IBOutlet weak var retweetedCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var isFavorite: UIButton!

    var shareHandler: ShareBlock?

    func share(handler: @escaping ShareBlock) {
        self.shareHandler = handler
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed(String(describing: TweetView.self), owner: self, options: nil)
        guard let baseView = baseView else { return }
        addConstraintedSubview(baseView)
    }

    @IBAction func shareTapped(_ sender: Any) {

        guard let button = sender as? UIButton, let shareHandler = shareHandler else { return }
        shareHandler(button)
    }
}
