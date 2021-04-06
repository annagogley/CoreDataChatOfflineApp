//
//  BlankPage.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 06.04.2021.
//

import UIKit
import Foundation

fileprivate var aView : UIView?

extension UIViewController {
    
    func blankPage(chats : Int) {
        print("blankPage chats \(chats)")
        if chats == 0 {
            Timer.scheduledTimer(withTimeInterval: K.timeInterval, repeats: false) { (t) in
                aView = UIView(frame: self.view.bounds)
                aView?.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: aView!.bounds.width, height: aView!.bounds.height))
                let sView = UIView(frame: self.view.bounds)
                sView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                
                label.center = aView!.center
                label.textAlignment = .center
                aView?.addSubview(label)
                aView?.addSubview(sView)
                label.text = "No chats here yet..."
                label.textColor = .darkGray
                label.font = .systemFont(ofSize: 20, weight: .bold)
                //            label.center = aView!.center
                UIView.animate(withDuration: 1.0) {
                        sView.alpha = 0.0
                    }
                
                self.view.addSubview(aView!)
                
                print("this func is working \(label)")
            }
        } else {
            hideBlankPage()
        }
    }
    
    func hideBlankPage() {
        aView?.removeFromSuperview()
        aView = nil
        print("hideBlankPage")
    }
    
    
}
