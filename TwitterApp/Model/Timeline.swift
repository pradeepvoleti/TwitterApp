//
//  Timeline.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import Foundation

typealias Timeline = [Tweet]

struct Tweet {
    let id: Int
    let text: String
    let favoriteCount, retweetCount: Int
    let favorited, retweeted: Bool
    let created: String
    let mediaURLs: [String]
    let user: User

    enum TimelineKeys: String, CodingKey {
        case id
        case text = "full_text"
        case retweetCount = "retweet_count"
        case favoriteCount = "favorite_count"
        case favorited, retweeted
        case created = "created_at"
        case user = "user"
        case extendedEntities = "extended_entities"
        case entities = "entities"

        enum EntitiesKeys: String, CodingKey {
            case media = "media"
            case url = "urls"

            enum MediaKeys: String, CodingKey {
                case mediaURLs = "media_url_https"
                case url = "url"
            }
        }
    }
}

extension Tweet: Decodable {
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: TimelineKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let tempText = try container.decode(String.self, forKey: .text)
        text = tempText.components(separatedBy: "http").first ?? tempText
        favoriteCount = try container.decode(Int.self, forKey: .favoriteCount)
        retweetCount = try container.decode(Int.self, forKey: .retweetCount)
        favorited = try container.decode(Bool.self, forKey: .favorited)
        retweeted = try container.decode(Bool.self, forKey: .retweeted)
        user = try container.decode(User.self, forKey: .user)

        let createdDate = try container.decode(String.self, forKey: .created)
        created = formatterDateFrom(string: createdDate) ?? ""

        var mediaUnkeyedContainer: UnkeyedDecodingContainer
        if container.contains(.extendedEntities) {
            let entitiesContainer = try container.nestedContainer(keyedBy: TimelineKeys.EntitiesKeys.self, forKey: .extendedEntities)
            mediaUnkeyedContainer = try entitiesContainer.nestedUnkeyedContainer(forKey: .media)

            var mediaURLs = [String]()
            while !mediaUnkeyedContainer.isAtEnd {
                let mediaContainer = try mediaUnkeyedContainer.nestedContainer(keyedBy: TimelineKeys.EntitiesKeys.MediaKeys.self)
                if container.contains(.extendedEntities) {
                    let urlString = try mediaContainer.decode(String.self, forKey: .mediaURLs)
                    mediaURLs.append(urlString)
                }
            }
            self.mediaURLs = mediaURLs.compactMap {$0}
        } else {
            self.mediaURLs = []
        }
    }
}

struct User: Decodable {

    let name: String
    let screenName: String
    let profilePicture: URL

    enum CodingKeys: String, CodingKey {
        case name
        case screenName = "screen_name"
        case profilePicture = "profile_image_url_https"
    }
}

func formatterDateFrom(string: String) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
    if let date = formatter.date(from: string) {
        formatter.dateFormat = "MMM dd"
        let dateString = formatter.string(from: date)
        return dateString
    } else {
        return nil
    }
}
