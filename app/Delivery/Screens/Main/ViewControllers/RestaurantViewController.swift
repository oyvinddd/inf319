//
//  RestaurantViewController.swift
//  Delivery
//
//  Created by Øyvind Hauge on 19/02/2021.
//

import UIKit

final class RestaurantViewController: UIViewController {
    
    private lazy var restaurantImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "restaurant-\(restaurant.id % 2 + 1).png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var backButtonView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "back-arrow.png")!.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.Text.primary
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        view.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        view.addGestureRecognizer(recognizer)
        view.applyCornerRadius(18)
        return view
    }()
    
    private lazy var infoWrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.Text.primary
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.Text.secondary
        label.text = "⭐️⭐️⭐️⭐️⭐️ 5.0 (500+ reviews)"
        return label
    }()
    
    private lazy var tabBarView: UIView = {
        return createTabBar()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.TableView.background
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.allowsMultipleSelection = false
        tableView.registerCell(FoodTableViewCell.self)
        return tableView
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton.create(with: "Order", backgroundColor: UIColor.Button.primary)
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        button.toggle(on: false)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        return indicator
    }()
    
    private var restaurant: Restaurant
    private var selectedFood: Food?
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
        self.nameLabel.text = restaurant.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViews()
        configureUI()
    }
    
    private func setupChildViews() {
        view.addSubview(restaurantImageView)
        view.addSubview(backButtonView)
        view.addSubview(infoWrapperView)
        infoWrapperView.addSubview(nameLabel)
        infoWrapperView.addSubview(ratingLabel)
        infoWrapperView.addSubview(tabBarView)
        infoWrapperView.addSubview(tableView)
        infoWrapperView.addSubview(orderButton)
        
        NSLayoutConstraint.activate([
            restaurantImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            restaurantImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            restaurantImageView.topAnchor.constraint(equalTo: view.topAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 190),
            backButtonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            backButtonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButtonView.widthAnchor.constraint(equalToConstant: 36),
            backButtonView.heightAnchor.constraint(equalTo: backButtonView.widthAnchor),
            infoWrapperView.leftAnchor.constraint(equalTo: view.leftAnchor),
            infoWrapperView.rightAnchor.constraint(equalTo: view.rightAnchor),
            infoWrapperView.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: -32),
            infoWrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: infoWrapperView.leftAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: infoWrapperView.rightAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: infoWrapperView.topAnchor, constant: 16),
            ratingLabel.leftAnchor.constraint(equalTo: infoWrapperView.leftAnchor, constant: 16),
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ratingLabel.rightAnchor.constraint(equalTo: infoWrapperView.rightAnchor, constant: -16),
            tabBarView.leftAnchor.constraint(equalTo: infoWrapperView.leftAnchor),
            tabBarView.rightAnchor.constraint(equalTo: infoWrapperView.rightAnchor),
            tabBarView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: infoWrapperView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: infoWrapperView.rightAnchor),
            tableView.topAnchor.constraint(equalTo: tabBarView.bottomAnchor),
            orderButton.leftAnchor.constraint(equalTo: infoWrapperView.leftAnchor, constant: 16),
            orderButton.rightAnchor.constraint(equalTo: infoWrapperView.rightAnchor, constant: -16),
            orderButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            orderButton.bottomAnchor.constraint(equalTo: infoWrapperView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            orderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureUI() {
        infoWrapperView.layer.masksToBounds = true
        infoWrapperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        infoWrapperView.layer.cornerRadius = 20
    }
    
    func toggleButtonLoading(_ loading: Bool) {
        orderButton.toggle(on: !loading)
        if loading {
            orderButton.setTitleColor(UIColor.clear, for: .normal)
            orderButton.addSubview(activityIndicator)
            centerActivityIndicator()
        } else {
            orderButton.setTitleColor(UIColor.white, for: .normal)
            if activityIndicator.superview != nil {
                activityIndicator.removeFromSuperview()
            }
        }
    }
    
    private func centerActivityIndicator() {
        activityIndicator.center = CGPoint(x: orderButton.frame.width / 2, y: orderButton.frame.height / 2)
    }
    
    // MARK: - Button Handling
    
    @objc private func orderButtonTapped() {
        guard let food = selectedFood else {
            return
        }
        toggleButtonLoading(true)
        let request = OrderRequest(customerId: Account.current.id, food: food)
        DeliveryService.Orders.create(request: request) { result in
            self.toggleButtonLoading(false)
            switch result {
            case .success(let order):
                print("Order created: \(order)")
                self.navigationController?.popViewController(animated: true)
                break
            case .failure(let error):
                print("Error creating order: \(error.localizedDescription)")
                break
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View Data Source

extension RestaurantViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: FoodTableViewCell.self, for: indexPath)
        cell.food = restaurant.menu[indexPath.row]
        return cell
    }
}

// MARK: - Table View Delegate

extension RestaurantViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFood(with: indexPath)
    }
    
    private func selectFood(with indexPath: IndexPath) {
        let food = restaurant.menu[indexPath.row]
        selectedFood = food
        if selectedFood != nil {
            orderButton.toggle(on: true)
            orderButton.setTitle("Order (189 NOK)".uppercased(), for: .normal)
        }
    }
}

// MARK: - Tab Bar

extension RestaurantViewController {
    
    private func createTabBar() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.TableView.background
        
        let info = createTabBarItem(title: "Info", active: false)
        let menu = createTabBarItem(title: "Menu", active: true)
        let directions = createTabBarItem(title: "Directions", active: false)
        let reviews = createTabBarItem(title: "Reviews", active: false)
        
        let stackView = UIStackView(arrangedSubviews: [info, menu, directions, reviews])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        
        view.addSubview(borderView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            borderView.leftAnchor.constraint(equalTo: view.leftAnchor),
            borderView.rightAnchor.constraint(equalTo: view.rightAnchor),
            borderView.topAnchor.constraint(equalTo: view.topAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: borderView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return view
    }
    
    private func createTabBarItem(title: String, active: Bool) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = active ? UIColor.Text.active : UIColor.Text.primary
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = title
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}
