//
//  TweetViewController.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import UIKit
import SDWebImage
import SKPhotoBrowser

class TweetViewController: UIViewController {

    var tweetData: Tweet?
    @IBOutlet weak var tweetView: TweetView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetView.profileimage.sd_setImage(with: tweetData?.user.profilePicture, completed: nil)
        tweetView.name.text = tweetData?.user.name
        tweetView.tweetText.text = tweetData?.text
        tweetView.userIdAndDuration.text = "@" + (tweetData?.user.screenName ?? "")
        tweetView.favoriteCount.text = "\(tweetData?.favoriteCount ?? 0)"
        tweetView.retweetedCount.text = "\(tweetData?.retweetCount ?? 0)"
        if tweetData?.favorited ?? false {
            tweetView.isFavorite.setImage(UIImage(named: "liked"), for: .normal)
        } else {
            tweetView.isFavorite.setImage(UIImage(named: "like"), for: .normal)
        }
        guard let urlarry = tweetData?.mediaURLs else { return }

        if urlarry.count == 0 {
            tweetView.baseImageStackHeight.constant = 0
            tweetView.baseImageStack.isHidden = true

        } else if urlarry.count == 1 {

            guard let url = URL(string: urlarry[0]) else { return }
            tweetView.image1.sd_setImage(with: url, placeholderImage: nil)
            tweetView.rightImageStack.isHidden = true

            tweetView.baseImageStackHeight.constant = 200
            tweetView.baseImageStack.isHidden = false

        } else if urlarry.count == 2 {

            guard let firstURL = URL(string: urlarry[0]), let secondURL = URL(string: urlarry[1]) else { return }
            tweetView.image1.sd_setImage(with: firstURL, placeholderImage: nil)
            tweetView.image2.sd_setImage(with: secondURL, placeholderImage: nil)
            tweetView.image3Height.isActive = true
            tweetView.image3Height.constant = 0
            tweetView.rightImageStack.distribution = .fillProportionally
            tweetView.rightImageStack.isHidden = false

            tweetView.baseImageStackHeight.constant = 200
            tweetView.baseImageStack.isHidden = false

        } else if urlarry.count > 2 {

            guard let firstURL = URL(string: urlarry[0]), let secondURL = URL(string: urlarry[1]), let thirdURL = URL(string: urlarry[2]) else { return }
            tweetView.image1.sd_setImage(with: firstURL, placeholderImage: nil)
            tweetView.image2.sd_setImage(with: secondURL, placeholderImage: nil)
            tweetView.image3.sd_setImage(with: thirdURL, placeholderImage: nil)
            tweetView.image3Height.isActive = false
            tweetView.rightImageStack.distribution = .fillEqually
            tweetView.rightImageStack.isHidden = false

            tweetView.baseImageStackHeight.constant = 200
            tweetView.baseImageStack.isHidden = false
        }

        if urlarry.count > 0 {
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            tweetView.image1.addGestureRecognizer(tap1)
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            tweetView.image2.addGestureRecognizer(tap2)
            let tap3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            tweetView.image3.addGestureRecognizer(tap3)
        }
    }

    @objc func imageTapped(gesture: UITapGestureRecognizer) {

        guard let urlarry = tweetData?.mediaURLs else { return }
        let tag = gesture.view?.tag

        var images = [SKPhoto]()
        for url in urlarry {
            let photo = SKPhoto.photoWithImageURL(url)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
        }

        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(tag ?? 0)
        present(browser, animated: true, completion: {})
    }
}
