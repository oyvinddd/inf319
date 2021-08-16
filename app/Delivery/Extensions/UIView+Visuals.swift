//
//  UIView+Visuals.swift
//  Delivery
//
//  Created by Øyvind Hauge on 23/03/2021.
//

import UIKit

extension UIView {
    
    func applyDropShadow(color: UIColor = UIColor.Text.secondary, radius: CGFloat = 10, opacity: Float = 0.4) {
        layer.shadowColor = color.cgColor
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
    }
    
    func applyCornerRadius(_ radius: CGFloat = 6) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}
