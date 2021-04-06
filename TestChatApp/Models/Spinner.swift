//
//  Spinner.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 06.04.2021.
//
import UIKit
import Foundation

fileprivate var aView : UIView?

extension UIViewController {
    
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        
        let activityIndicator = UIImageView(image: UIImage(named: "activityIndicator"))
        
        aView?.addSubview(activityIndicator)
        activityIndicator.center = aView!.center
        activityIndicator.rotate()
        
        self.view.addSubview(aView!)

        
        Timer.scheduledTimer(withTimeInterval: K.timeInterval, repeats: false) { (t) in
            self.hideSpinner()
        }
       
    }
    
    func hideSpinner() {
        aView?.removeFromSuperview()
        aView = nil
        print("spinner is hidden \(K.timeInterval)")
    }
    
    
}

extension UIView {
    func rotate() {
        let rotation : CABasicAnimation = CASpringAnimation(keyPath: "transform.rotation")
        
        
        rotation.fromValue = 0.0
        rotation.toValue = NSNumber(value: Double.pi * 1.5)
        rotation.duration = 1.0
        rotation.isCumulative = true
        
        rotation.repeatCount = Float.infinity
        self.layer.add(rotation, forKey: "transform.rotation")
    }
}
