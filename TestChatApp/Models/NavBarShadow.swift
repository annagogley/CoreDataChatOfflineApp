//
//  NavBarShadow.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 06.04.2021.
//

import Foundation
import UIKit

extension UIViewController {
    func navbarView(height : Int) {
        let navbar = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: height + 20))
        navbar.backgroundColor = UIColor.white
        navbar.dropshadow(color: .black, opacity: 0.38, radius: 7)
        self.view.addSubview(navbar)
    }
}
