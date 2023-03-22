//
//  LoginViewController.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {

    @IBAction func loginTapped(_ sender: Any) {
        guard let oAuth = APIManager.shared.oAuth else { return }
        oAuth.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oAuth)
        APIManager.shared.authorize {[unowned self] in
            self.performSegue(withIdentifier: TwitterSegues.showFeedSegue, sender: nil)
        }
    }
}
