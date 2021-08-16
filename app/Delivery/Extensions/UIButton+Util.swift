//
//  UIButton+Util.swift
//  Delivery
//
//  Created by Øyvind Hauge on 12/05/2021.
//

import UIKit

extension UIButton {
    
    func toggle(on: Bool) {
        if on {
            isUserInteractionEnabled = true
            backgroundColor = UIColor.Button.primary
        } else {
            isUserInteractionEnabled = false
            backgroundColor = UIColor.Button.disabled
        }
    }
}
