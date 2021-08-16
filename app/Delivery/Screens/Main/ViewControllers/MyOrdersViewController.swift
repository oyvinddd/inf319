//
//  MyOrdersViewController.swift
//  Delivery
//
//  Created by Øyvind Hauge on 12/05/2021.
//

import UIKit

final class MyOrdersViewController: UIViewController {
    
    private lazy var topBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.Text.primary
        label.text = "My Orders"
        
        view.addSubview(label)
        view.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            subtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            subtitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.Text.secondary
        subtitleLabel.text = "Active orders show up below"
        return subtitleLabel
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.addSubview(refreshControl)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.registerCell(OrderTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl(frame: .zero)
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        control.tintColor = .lightGray
        return control
    }()
    
    private var orders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupChildViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchOrders()
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
    
    @objc private func refresh() {
        fetchOrders()
    }
    
    @objc private func fetchOrders() {
        DeliveryService.Orders.list { result in
            switch result {
            case .success(let orders):
                self.orders = orders
            case .failure(let error):
                print("Error fetching orders from server: \(error.localizedDescription)")
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            if self.orders.count > 0 {
                self.subtitleLabel.text = "You have \(self.orders.count) active order(s)"
            }
        }
    }
}

// MARK: - Table View Data Source

extension MyOrdersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: OrderTableViewCell.self, for: indexPath)
        cell.order = orders[indexPath.row]
        return cell
    }
}
