//
//  UIView+Extensions.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/25.
//

import Foundation
import UIKit
import MaterialComponents


public extension UIView {
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    func adaptiveColor() -> UIColor {
        if self.traitCollection.userInterfaceStyle == .dark {
            return UIColor.white
        }
        else {
            return UIColor.darkText
        }
    }
    
    
    func adaptiveBgColor() -> UIColor {
        if self.traitCollection.userInterfaceStyle == .dark {
            return UIColor.white
        }
        else {
            return UIColor.darkText
        }
    }
}
public extension UIViewController {
    
    func adaptiveColor() -> UIColor {
        if self.traitCollection.userInterfaceStyle == .dark {
            return UIColor.white
        }
        else {
            return UIColor.darkText
        }
    }
}

public func startDayAndEndDay() -> (start:Date,end:Date) {
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let todayEnd: Date = {
        let components = DateComponents(day: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: todayStart)!
    }()
    
    return (todayStart, todayEnd)
}


enum RealmError: Error {
  case write
}

