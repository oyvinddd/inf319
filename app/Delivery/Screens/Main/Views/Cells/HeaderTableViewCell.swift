//
//  HeaderTableViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 23/03/2021.
//

import UIKit

final class HeaderTableViewCell: UITableViewCell {
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.Text.primary
        return label
    }()
    
    var header: String? {
        didSet {
            headerLabel.text = header
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupChildViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChildViews() {
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            headerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
