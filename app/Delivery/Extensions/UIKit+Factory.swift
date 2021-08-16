//
//  UIKit+Factory.swift
//  Delivery
//
//  Created by Øyvind Hauge on 02/05/2021.
//

import UIKit

extension UIButton {
    
    class func create(with title: String, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.applyCornerRadius(8)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle(title.uppercased(), for: .normal)
        return button
    }
}
