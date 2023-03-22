//
//  Extensions.swift
//  TwitterApp
//
//  Created by pradeep.voleti on 10/12/18.
//  Copyright © 2018 pradeep.voleti. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintedSubview(_ view: UIView) {

        view.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)

        addSubview(view)
        addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        layoutIfNeeded()
    }
}
