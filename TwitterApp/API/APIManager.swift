//
//  APIManager.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import Foundation
import OAuthSwift
import KeychainAccess
import Alamofire
import OAuthSwiftAlamofire

class APIManager {

    static let shared = APIManager()
    let sessionManager = SessionManager.default
    var oAuth: OAuth1Swift?

    private init() {
        oAuth = OAuth1Swift(consumerKey: Keys.consumerKey.rawValue,
                            consumerSecret: Keys.consumerSecret.rawValue,
                            requestTokenUrl: AuthURLs.requestTokenURL.rawValue,
                            authorizeUrl: AuthURLs.authorizeURL.rawValue,
                            accessTokenUrl: AuthURLs.accessTokenURL.rawValue)

        if let credential = KeyChainManager.shared.fetchCredential() {
            oAuth?.client.credential.oauthToken = credential.oauthToken
            oAuth?.client.credential.oauthTokenSecret = credential.oauthTokenSecret
        }

        sessionManager.adapter = oAuth?.requestAdapter
    }

    func authorize(handler: @escaping () -> Void) {

        guard let oAuth = oAuth, let url = URL(string: AuthURLs.callbackURL.rawValue) else { return }

        oAuth.authorize(withCallbackURL: url,
                         success: { (credential, _, _) in
                            KeyChainManager.shared.save(credential: credential)
                            handler()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func getHomeTimeline(completion: @escaping (Timeline?) -> Void) {
        guard let url = URL(string: baseURL + APIPath.homeTimeline.rawValue) else { return }
        sessionManager.request(url).responseJSON { (response) in
            response.result.ifSuccess {

                if let data = response.data, let model = try? JSONDecoder().decode(Timeline.self, from: data) {
                    completion(model)
                    return
                }
                completion(nil)
            }
        }
    }

    func logout() {
        KeyChainManager.shared.clearCredential()
        NotificationCenter.default.post(name: NSNotification.Name(logoutNotification), object: nil)
    }

    func handle(url: URL) {
        OAuth1Swift.handle(url: url)
    }

    func isLoggedIn() -> Bool {
        return KeyChainManager.shared.fetchCredential() != nil
    }
}

private class KeyChainManager {

    let twitterCredential = "twitterCredential"
    static let shared = KeyChainManager()
    private init() { }

    func save(credential: OAuthSwiftCredential) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: credential, requiringSecureCoding: true)
            try Keychain().set(data, key: twitterCredential)
        } catch { }
    }

    func fetchCredential() -> OAuthSwiftCredential? {
        do {
            guard let data = try Keychain().getData(twitterCredential) else { return nil }
            let credential = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? OAuthSwiftCredential
            return credential
        } catch { }
        return nil
    }

    func clearCredential() {
        do {
            try Keychain().remove(twitterCredential)
        } catch { }
    }
}
