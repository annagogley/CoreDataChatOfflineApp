//
//  DropShadowExtension.swift
//  TestChatApp
//
//  Created by Аня Воронцова on 15.03.2021.
//

import Foundation
import UIKit

extension UIView {
    func dropshadow(color: UIColor, opacity: Float, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
}

public extension UIImage {

    //
    /// Tint Image
    ///
    /// - Parameter fillColor: UIColor
    /// - Returns: Image with tint color
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))

        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        return imageColored
    }
}
