//
//  SpecialOfferTableViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 21/03/2021.
//

import UIKit

private let kCollectionViewCellWidth: CGFloat = 120
private let kCollectionViewCellHeight: CGFloat = 140

final class SpecialOfferTableViewCell: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        // collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kCollectionViewCellWidth, height: kCollectionViewCellHeight)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OfferCollectionViewCell.self,
                                forCellWithReuseIdentifier: OfferCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()
    
    var offers: [SpecialOffer] = [
        SpecialOffer(
            id: 2,
            customerID: 3,
            price: 199,
            food: Food(restaurantId: 3, type: 4, name: "Steak", lowerPrice: 199, normalPrice: 229, preparationTime: 0, expirationTime: 0),
            expirationTime: "EXPIRES IN 02:11"
        ),
        SpecialOffer(
            id: 0,
            customerID: 0,
            price: 119,
            food: Food(restaurantId: 0, type: 1, name: "Sushi", lowerPrice: 119, normalPrice: 159, preparationTime: 0, expirationTime: 0),
            expirationTime: "EXPIRES IN 05:01"),
        SpecialOffer(
            id: 1,
            customerID: 1,
            price: 129,
            food: Food(restaurantId: 1, type: 0, name: "Burger", lowerPrice: 129, normalPrice: 189, preparationTime: 0, expirationTime: 0),
            expirationTime: "EXPIRES IN 05:22"
        )
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
    
    private func setupChildViews() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: kCollectionViewCellHeight)
        ])
    }
}

// MARK: - Collection View Data Source

extension SpecialOfferTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: OfferCollectionViewCell.self, for: indexPath)
        cell.offer = offers[indexPath.row]
        return cell
    }
}
