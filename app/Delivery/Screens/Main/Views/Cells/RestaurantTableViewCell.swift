//
//  RestaurantTableViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 21/01/2021.
//

import UIKit

final class RestaurantTableViewCell: UITableViewCell {
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.applyCornerRadius(10)
        view.applyDropShadow()
        return view
    }()
    
    private lazy var restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    private lazy var openStatusWrap: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Text.primary
        view.applyCornerRadius(2)
        view.alpha = 0.8
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "open".uppercased()
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2)
        ])
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.Text.primary
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Text.secondary
        return label
    }()
    
    var restaurant: Restaurant? {
        didSet {
            guard let restaurant = restaurant else { return }
            restaurantImageView.image = UIImage(named: "restaurant-\(restaurant.id % 2 + 1).png")
            titleLabel.text = restaurant.name
            addressLabel.text = "Damsgårdsveien 105, 5058 Bergen"
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
        addSubview(wrapperView)
        wrapperView.addSubview(restaurantImageView)
        wrapperView.addSubview(openStatusWrap)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            wrapperView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            wrapperView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            wrapperView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            restaurantImageView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            restaurantImageView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
            restaurantImageView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            restaurantImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            restaurantImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 110),
            openStatusWrap.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 12),
            openStatusWrap.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 12),
            addressLabel.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 12),
            addressLabel.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -12),
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            addressLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -12)
        ])
    }
}
