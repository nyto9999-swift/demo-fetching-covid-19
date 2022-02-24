//
//  UIView+Extensions.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/25.
//

import Foundation
import UIKit


public extension UIView {
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -20.0).isActive = true
    }
}
