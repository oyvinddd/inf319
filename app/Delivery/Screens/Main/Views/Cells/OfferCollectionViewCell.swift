//
//  OfferCollectionViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 23/03/2021.
//

import UIKit

final class OfferCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OfferCollectionViewCell.self)
    
    private let emojisAndColors: [(String, UIColor)] = [
        ("🍔", UIColor.Food.burger),
        ("🍣", UIColor.Food.sushi),
        ("🍝", UIColor.Food.pasta),
        ("🐠", UIColor.Food.fish),
        ("🥩", UIColor.Food.steak),
        ("🍕", UIColor.Food.pizza),
        ("🥗", UIColor.Food.salad),
        ("🐔", UIColor.Food.chicken),
        ("🦑", UIColor.Food.squid),
        ("🍜", UIColor.Food.ramen),
    ]
    
    var offer: SpecialOffer? {
        didSet {
            configureUI(offer: offer)
        }
    }
    
    private lazy var wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Offer.one
        view.applyCornerRadius(12)
        return view
    }()
    
    private lazy var emojiWrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(emojiLabel)
        view.applyCornerRadius(32)
        view.applyDropShadow(color: UIColor.Text.primary, radius: 7, opacity: 0.3)
        
        NSLayoutConstraint.activate([
            emojiLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            emojiLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            emojiLabel.topAnchor.constraint(equalTo: view.topAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        label.text = "🐶"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.Text.primary
        label.textAlignment = .center
        return label
    }()
    
    private lazy var expirationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = UIColor.Text.primary
        label.textAlignment = .center
        label.text = "EXPIRES IN 02:11"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupChildViews()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChildViews() {
        addSubview(wrapperView)
        wrapperView.addSubview(priceLabel)
        wrapperView.addSubview(expirationLabel)
        wrapperView.addSubview(emojiWrapperView)
        
        NSLayoutConstraint.activate([
            wrapperView.leftAnchor.constraint(equalTo: leftAnchor),
            wrapperView.rightAnchor.constraint(equalTo: rightAnchor),
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emojiWrapperView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 26),
            emojiWrapperView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -26),
            emojiWrapperView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 14),
            emojiWrapperView.heightAnchor.constraint(equalTo: emojiWrapperView.widthAnchor),
            priceLabel.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            priceLabel.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
            priceLabel.topAnchor.constraint(equalTo: emojiWrapperView.bottomAnchor, constant: 10),
            expirationLabel.leftAnchor.constraint(equalTo: wrapperView.leftAnchor),
            expirationLabel.rightAnchor.constraint(equalTo: wrapperView.rightAnchor),
            expirationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2)
        ])
    }
    
    private func configureUI(offer: SpecialOffer?) {
        guard let offer = offer else { return }
        priceLabel.text = "\(offer.price) NOK"
        let (emoji, color) = emojisAndColors[offer.food.type]
        wrapperView.backgroundColor = color
        emojiLabel.text = emoji
        expirationLabel.text = offer.expirationTime
    }
}
