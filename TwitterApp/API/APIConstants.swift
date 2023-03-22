//
//  APIConstants.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import Foundation

enum Keys: String {
    case consumerKey = ""
    case consumerSecret = ""
}

enum AuthURLs: String {
    case requestTokenURL = "https://api.twitter.com/oauth/request_token"
    case authorizeURL = "https://api.twitter.com/oauth/authorize"
    case accessTokenURL = "https://api.twitter.com/oauth/access_token"
    case callbackURL = "twitterApp://"
}

let baseURL = "https://api.twitter.com/1.1"

enum APIPath: String {
    case homeTimeline = "/statuses/home_timeline.json?tweet_mode=extended"
}
