//
//  OrderTableViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 12/05/2021.
//

import UIKit

final class OrderTableViewCell: UITableViewCell {
    
    private lazy var contentWrap: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.applyCornerRadius(10)
        view.applyDropShadow()
        return view
    }()
    
    private lazy var imageWrap: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.applyCornerRadius(6)
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.text = "🐶"
        return label
    }()
    
    private lazy var foodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.Text.primary
        return label
    }()
    
    private lazy var restaurantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.Text.secondary
        return label
    }()
    
    var order: Order? {
        didSet {
            configureUI(order)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupChildViews()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChildViews() {
        addSubview(contentWrap)
        contentWrap.addSubview(imageWrap)
        contentWrap.addSubview(foodLabel)
        contentWrap.addSubview(restaurantLabel)
        imageWrap.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            contentWrap.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            contentWrap.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            contentWrap.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentWrap.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            imageWrap.leftAnchor.constraint(equalTo: contentWrap.leftAnchor, constant: 8),
            imageWrap.topAnchor.constraint(equalTo: contentWrap.topAnchor, constant: 8),
            imageWrap.bottomAnchor.constraint(equalTo: contentWrap.bottomAnchor, constant: -8),
            imageWrap.widthAnchor.constraint(equalTo: imageWrap.heightAnchor),
            emojiLabel.leftAnchor.constraint(equalTo: imageWrap.leftAnchor),
            emojiLabel.rightAnchor.constraint(equalTo: imageWrap.rightAnchor),
            emojiLabel.topAnchor.constraint(equalTo: imageWrap.topAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: imageWrap.bottomAnchor),
            foodLabel.leftAnchor.constraint(equalTo: imageWrap.rightAnchor, constant: 16),
            foodLabel.topAnchor.constraint(equalTo: contentWrap.topAnchor, constant: 16),
            restaurantLabel.leftAnchor.constraint(equalTo: imageWrap.rightAnchor, constant: 16),
            restaurantLabel.topAnchor.constraint(equalTo: foodLabel.bottomAnchor, constant: 8),
            restaurantLabel.bottomAnchor.constraint(equalTo: contentWrap.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureUI(_ order: Order?) {
        guard let order = order else { return }
        foodLabel.text = order.food.name
        restaurantLabel.text = "\(order.origin.name) • \(order.food.normalPrice) NOK"
        let (emoji, color) = order.food.emojiAndColor()
        emojiLabel.text = emoji
        imageWrap.backgroundColor = color
    }
}
