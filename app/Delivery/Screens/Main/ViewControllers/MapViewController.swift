//
//  MapViewController.swift
//  Delivery
//
//  Created by Øyvind Hauge on 12/05/2021.
//

import UIKit

final class MapViewController: UIViewController {
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Text.secondary
        label.text = "Screen not implemented"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            placeholderLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: view.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
