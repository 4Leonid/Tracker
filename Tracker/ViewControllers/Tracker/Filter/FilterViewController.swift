//
//  FilterViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 18.03.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
  func setFilter(filter: Filter)
}

final class FilterViewController: UIViewController {
  
  // MARK: - Public Properties
  weak var trackersViewController: TrackerViewController?
  weak var delegate: FilterViewControllerDelegate?
  
  // MARK: - Elements
  private lazy var filterTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
    tableView.allowsMultipleSelection = false
    tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier) // Используем готовую ячейку из категорий
    return tableView
  }()
  
  // MARK: - Private Properties
  private var selectedFilter: Filter? {
    didSet {
      guard let selectedFilter = selectedFilter else { return }
      delegate?.setFilter(filter: selectedFilter)
    }
  }
  
  // MARK: - Lifecycle & Initialize
  override func viewDidLoad() {
    super.viewDidLoad()
    viewSetting()
  }
  
  init(selectedFilter: Filter?) {
    self.selectedFilter = selectedFilter
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods (public & private)
  func didSelectRow(index: IndexPath) {
    selectedFilter = Filter.allCases[index.row]
    filterTableView.reloadData()
  }
  
  private func viewSetting() {
    view.addSubview(filterTableView)
    title = "filterVC_title".localized
    view.backgroundColor = .yaWhite
    filterTableView.dataSource = self
    filterTableView.delegate = self
    
    NSLayoutConstraint.activate([
      filterTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      filterTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      filterTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      filterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -114)
    ])
  }
}

// MARK: - Extension - TableView Data Source
extension FilterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Filter.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as? CategoryCell else { return UITableViewCell() }
    
    let position: CellBackgroundSetting.Position
    let filter = Filter.allCases[indexPath.row]
    let active = filter == selectedFilter
    
    switch indexPath.row {
    case 0:
      position = .top
    case 1...2:
      position = .middle
    case 3:
      position = .bottom
    default:
      position = .common
    }
    
    cell.configure(name: filter.name, isActive: active, position: position)
    return cell
  }
}

// MARK: - Extension - TableView Delegate
extension FilterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    didSelectRow(index: indexPath)
  }
}
