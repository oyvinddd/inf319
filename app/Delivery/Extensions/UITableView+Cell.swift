//
//  UITableView+Cell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 23/01/2021.
//

import UIKit

extension UITableView {

    private func reuseIndentifier<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIndentifier(for: type), for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
        }
        return cell
    }
    
    public func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: reuseIndentifier(for: type))
    }
}
