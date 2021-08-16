//
//  FoodTableViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 02/05/2021.
//

import UIKit

final class FoodTableViewCell: UITableViewCell {
    
    private lazy var wrapperView: UIView = {
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.Text.primary
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Text.secondary
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var radioButtonImageView: UIImageView = {
        let imageView = UIImageView(image: radioButtonOffImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.Text.secondary
        return imageView
    }()
    
    private lazy var radioButtonOffImage: UIImage = {
        return UIImage(named: "radio-off-button.png")!.withRenderingMode(.alwaysTemplate)
    }()
    
    private lazy var radioButtonOnImage: UIImage = {
        return UIImage(named: "radio-on-button.png")!.withRenderingMode(.alwaysTemplate)
    }()
    
    var food: Food? {
        didSet {
            updateUI(with: food)
        }
    }
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupChildViews()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        toggleRadioButton(on: selected)
    }
    
    private func setupChildViews() {
        addSubview(wrapperView)
        wrapperView.addSubview(imageWrap)
        wrapperView.addSubview(titleLabel)
        wrapperView.addSubview(priceLabel)
        wrapperView.addSubview(radioButtonImageView)
        imageWrap.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            wrapperView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            wrapperView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            wrapperView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            imageWrap.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: 8),
            imageWrap.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 8),
            imageWrap.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -8),
            imageWrap.widthAnchor.constraint(equalTo: imageWrap.heightAnchor),
            titleLabel.leftAnchor.constraint(equalTo: imageWrap.rightAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(greaterThanOrEqualTo: wrapperView.rightAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -8),
            priceLabel.leftAnchor.constraint(equalTo: imageWrap.rightAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -16),
            emojiLabel.leftAnchor.constraint(equalTo: imageWrap.leftAnchor),
            emojiLabel.rightAnchor.constraint(equalTo: imageWrap.rightAnchor),
            emojiLabel.topAnchor.constraint(equalTo: imageWrap.topAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: imageWrap.bottomAnchor),
            radioButtonImageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            radioButtonImageView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor, constant: -16),
            radioButtonImageView.widthAnchor.constraint(equalToConstant: 18),
            radioButtonImageView.heightAnchor.constraint(equalTo: radioButtonImageView.widthAnchor)
        ])
    }
    
    private func updateUI(with food: Food?) {
        guard let food = food else { return }
        titleLabel.text = food.name
        priceLabel.text = "\(food.normalPrice) NOK"
        if food.type >= 0 && food.type <= 9 {
            let emoji = emojisAndColors[food.type].0
            let backgroundColor = emojisAndColors[food.type].1
            emojiLabel.text = emoji
            imageWrap.backgroundColor = backgroundColor
        }
    }
    
    private func toggleRadioButton(on: Bool) {
        if on {
            radioButtonImageView.image = radioButtonOnImage
            radioButtonImageView.tintColor = UIColor.Button.primary
        } else {
            radioButtonImageView.image = radioButtonOffImage
            radioButtonImageView.tintColor = UIColor.Text.secondary
        }
    }
}
