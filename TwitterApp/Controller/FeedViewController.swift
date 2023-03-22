//
//  FeedViewController.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class FeedViewController: UIViewController {

    @IBOutlet weak var feedTable: UITableView!
    var timeline: Timeline?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweetsTimeline()

        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = logout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == TwitterSegues.showTweetSegue {
            guard let destinationVC = segue.destination as? TweetViewController, let tweet = sender as? Tweet else { return }
            destinationVC.tweetData = tweet
        }
    }

    @objc func logoutTapped() {
        APIManager.shared.logout()
    }

    func fetchTweetsTimeline() {
        APIManager.shared.getHomeTimeline { [unowned self] (timeline) in
            self.timeline = timeline
            self.feedTable.reloadData()
        }
    }

    func shareCallback(button: UIButton) {

        let activity = [
                    UIActivity.ActivityType.postToFacebook,
                    UIActivity.ActivityType.postToTwitter,
                    UIActivity.ActivityType.message,
                    UIActivity.ActivityType.mail,
                    UIActivity.ActivityType.print,
                    UIActivity.ActivityType.copyToPasteboard,
                    UIActivity.ActivityType.airDrop]
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: activity, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = button
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.feedCell, for: indexPath) as? TweetCell else { return UITableViewCell() }
        guard let tweet = timeline?[indexPath.row] else { return cell }
        cell.tweetView.name.text = tweet.user.name
        cell.tweetView.tweetText.text = tweet.text
        cell.tweetView.userIdAndDuration.text = "@\(tweet.user.screenName) - \(tweet.created)"
        cell.tweetView.tag = indexPath.row
        cell.tweetView.profileimage.sd_setImage(with: tweet.user.profilePicture, completed: nil)
        cell.tweetView.favoriteCount.text = "\(tweet.favoriteCount)"
        cell.tweetView.retweetedCount.text = "\(tweet.retweetCount)"
        if tweet.favorited {
            cell.tweetView.isFavorite.setImage(UIImage(named: "liked"), for: .normal)
        } else {
            cell.tweetView.isFavorite.setImage(UIImage(named: "like"), for: .normal)
        }

        cell.tweetView.share(handler: shareCallback)
        let urlarry = tweet.mediaURLs

        if urlarry.count == 0 {
            cell.tweetView.baseImageStackHeight.constant = 0
            cell.tweetView.baseImageStack.isHidden = true

        } else if urlarry.count == 1 {

            guard let url = URL(string: urlarry[0]) else { return cell }
            cell.tweetView.image1.sd_setImage(with: url, placeholderImage: nil)
            cell.tweetView.rightImageStack.isHidden = true

            cell.tweetView.baseImageStackHeight.constant = 200
            cell.tweetView.baseImageStack.isHidden = false

        } else if urlarry.count == 2 {

            guard let firstURL = URL(string: urlarry[0]), let secondURL = URL(string: urlarry[1]) else { return cell }
            cell.tweetView.image1.sd_setImage(with: firstURL, placeholderImage: nil)
            cell.tweetView.image2.sd_setImage(with: secondURL, placeholderImage: nil)
            cell.tweetView.image3Height.isActive = true
            cell.tweetView.image3Height.constant = 0
            cell.tweetView.rightImageStack.distribution = .fillProportionally
            cell.tweetView.rightImageStack.isHidden = false

            cell.tweetView.baseImageStackHeight.constant = 200
            cell.tweetView.baseImageStack.isHidden = false

        } else if urlarry.count > 2 {

            guard let firstURL = URL(string: urlarry[0]), let secondURL = URL(string: urlarry[1]), let thirdURL = URL(string: urlarry[2]) else { return cell }
            cell.tweetView.image1.sd_setImage(with: firstURL, placeholderImage: nil)
            cell.tweetView.image2.sd_setImage(with: secondURL, placeholderImage: nil)
            cell.tweetView.image3.sd_setImage(with: thirdURL, placeholderImage: nil)
            cell.tweetView.image3Height.isActive = false
            cell.tweetView.rightImageStack.distribution = .fillEqually
            cell.tweetView.rightImageStack.isHidden = false

            cell.tweetView.baseImageStackHeight.constant = 200
            cell.tweetView.baseImageStack.isHidden = false
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: TwitterSegues.showTweetSegue, sender: timeline?[indexPath.row])
    }
}
