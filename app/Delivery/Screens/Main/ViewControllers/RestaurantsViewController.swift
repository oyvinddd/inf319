//
//  MainViewController.swift
//  Delivery
//
//  Created by Øyvind Hauge on 20/01/2021.
//

import UIKit

final class RestaurantsViewController: UIViewController {
    
    private enum TableViewType: Int {
        case search, header1, offer, header2, restaurant
    }
    
    private lazy var topBar: TopBar = {
        return TopBar(account: Account.current, delegate: self)
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl(frame: .zero)
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        control.tintColor = .lightGray
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.addSubview(refreshControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.registerCell(RestaurantTableViewCell.self)
        tableView.registerCell(SpecialOfferTableViewCell.self)
        tableView.registerCell(SearchTableViewCell.self)
        tableView.registerCell(HeaderTableViewCell.self)
        return tableView
    }()
    
    // list of restaurants fetched from server
    private var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        fetchRestaurants()
    }
    
    private func setupChildViews() {
        view.addSubview(topBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            topBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            topBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            topBar.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func fetchRestaurants() {
        DeliveryService.Restaurants.list { result in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let restaurants):
                self.restaurants = restaurants
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching restaurants from server: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func refresh() {
        fetchRestaurants()
    }
}

// MARK: - Table View Data Source

extension RestaurantsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewType.restaurant.rawValue + restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFromIndexPath(indexPath)
    }
    
    private func cellFromIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        // search bar
        if indexPath.row == TableViewType.search.rawValue {
            return tableView.dequeueReusableCell(for: SearchTableViewCell.self, for: indexPath)
        }
        // header 1
        if indexPath.row == TableViewType.header1.rawValue {
            let cell = tableView.dequeueReusableCell(for: HeaderTableViewCell.self, for: indexPath)
            cell.header = "Special Offers 🔥"
            return cell
        }
        // special offers
        if indexPath.row == TableViewType.offer.rawValue {
            return tableView.dequeueReusableCell(for: SpecialOfferTableViewCell.self, for: indexPath)
        }
        if indexPath.row == TableViewType.header2.rawValue {
            let cell = tableView.dequeueReusableCell(for: HeaderTableViewCell.self, for: indexPath)
            cell.header = "Nearby Restaurants"
            return cell
        }
        // restaurants
        let cell = tableView.dequeueReusableCell(for: RestaurantTableViewCell.self, for: indexPath)
        cell.restaurant = restaurants[indexPath.row - TableViewType.restaurant.rawValue]
        return cell
    }
}

// MARK: - Table View Delegate

extension RestaurantsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // restaurant list starts at row 4
        if indexPath.row > 3 {
            let index = indexPath.row - 4
            let viewController = RestaurantViewController(restaurant: restaurants[index])
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - Top Bar Delegate

extension RestaurantsViewController: TopBarDelegate {
    
    func didTapProfilePicture() {
        present(PopUpViewController(), animated: false, completion: nil)
    }
}
