//
//  SearchTableViewCell.swift
//  Delivery
//
//  Created by Øyvind Hauge on 24/01/2021.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    private lazy var searchWrap: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.TextField.background
        view.applyCornerRadius(6)
        return view
    }()
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.placeholder = "Search for restaurants"
        return textField
    }()
    
    private lazy var filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.TextField.background
        view.applyCornerRadius(6)
        
        let image = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.Text.secondary
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupChildViews()
        backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupChildViews() {
        contentView.addSubview(searchWrap)
        contentView.addSubview(filterView)
        searchWrap.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchWrap.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            searchWrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            searchWrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            searchField.leftAnchor.constraint(equalTo: searchWrap.leftAnchor, constant: 8),
            searchField.topAnchor.constraint(equalTo: searchWrap.topAnchor, constant: 10),
            searchField.bottomAnchor.constraint(equalTo: searchWrap.bottomAnchor, constant: -10),
            filterView.leftAnchor.constraint(equalTo: searchWrap.rightAnchor, constant: 16),
            filterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            filterView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            filterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            filterView.widthAnchor.constraint(equalTo: filterView.heightAnchor)
        ])
    }
}
