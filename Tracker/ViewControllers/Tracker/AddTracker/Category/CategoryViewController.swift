//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
  func didConfirm(category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
  
  // MARK: - Elements
  private lazy var categoryTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = true
    tableView.allowsMultipleSelection = false
    tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
    return tableView
  }()
  
  private lazy var addCategoryButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .yaBlack
    button.setTitleColor(.yaWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.setTitle("categoryVC_addCategoryButton".localized, for: .normal)
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Properties
  weak var delegate: CategoryViewControllerDelegate?
  private let categoryPlaceholder = UIStackView()
  private let viewModel: CategoryViewModel
  
  // MARK: - Initializer
  init(category: TrackerCategory?) {
    viewModel = CategoryViewModel(selectedCategory: category)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubViews()
    viewSetting()
    applyConstraint()
    viewModel.loadCategories()
    categoryPlaceholder.configure(
      name: "starPlaceholder",
      text: "categoryVC_placeholderText".localized
    )
  }
  
  
  // MARK: - Layout & Setting
  private func addSubViews() {
    [categoryTableView, addCategoryButton, categoryPlaceholder].forEach { view.addSubview($0) }
  }
  
  private func viewSetting() {
    title = "settingTrackerVC_categoryParamLabel".localized
    view.backgroundColor = .yaWhite
    categoryTableView.dataSource = self
    categoryTableView.delegate = self
    viewModel.delegate = self
  }
  
  private func applyConstraint() {
    NSLayoutConstraint.activate([
      categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      categoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -114),
      addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
      categoryPlaceholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      categoryPlaceholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
    ])
  }
  
  // MARK: - Actions
  @objc private func didTapAddButton() {
    let addCategoryVC = AddCategoryViewController()
    addCategoryVC.delegate = self
    let navigationController = UINavigationController(rootViewController: addCategoryVC)
    present(navigationController, animated: true)
  }
  
  // MARK: - Methods
  private func editCategory(from category: TrackerCategory) {
    let addCategoryVC = AddCategoryViewController(data: category.data)
    addCategoryVC.delegate = self
    let navigationController = UINavigationController(rootViewController: addCategoryVC)
    present(navigationController, animated: true)
  }
  
  private func deleteCategory(from category: TrackerCategory) {
    let alert = UIAlertController(title: nil, message: "categoryVC_alertMessageWhenDeleteCategory".localized, preferredStyle: .actionSheet)
    let deleteAction = UIAlertAction(title: "categoryVC_alertActionDelete".localized, style: .destructive) { [weak self] _ in
      self?.viewModel.deleteCategory(category: category)
    }
    let cancelAction = UIAlertAction(title: "categoryVC_alertActionCancel".localized, style: .cancel)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }
}

// MARK: - TableView DataSource
extension CategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.categories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as? CategoryCell else { return UITableViewCell() }
    let category = viewModel.categories[indexPath.row]
    let active = viewModel.selectedCategory == category
    let position: CellBackgroundSetting.Position
    
    switch indexPath.row {
    case 0:
      position = viewModel.categories.count == 1 ? .common : .top
    case viewModel.categories.count - 1:
      position = .bottom
    default:
      position = .middle
    }
    cell.configure(name: category.name, isActive: active, position: position)
    return cell
  }
  
  func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let category = viewModel.categories[indexPath.row]
    
    return UIContextMenuConfiguration(actionProvider: { _ in
      UIMenu(children: [
        UIAction(title: "categoryVC_alertActionEdit".localized) { [weak self] _ in
          self?.editCategory(from: category)
        },
        UIAction(title: "categoryVC_alertActionDelete".localized, attributes: .destructive) { [weak self] _ in
          self?.deleteCategory(from: category)
        }
      ])
    })
  }
}

// MARK: - TableView Delegate
extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectCategories(indexPath: indexPath)
  }
}

// MARK: - ViewModel Delegate
extension CategoryViewController: CategoryViewModelDelegate {
  func didUpdateCategories() {
    if viewModel.categories.isEmpty {
      categoryPlaceholder.isHidden = false
    } else {
      categoryPlaceholder.isHidden = true
    }
    categoryTableView.reloadData()
  }
  
  func didSelectCategory(category: TrackerCategory) {
    delegate?.didConfirm(category: category)
  }
}

// MARK: - AddCategory Delegate
extension CategoryViewController: AddCategoryViewControllerDelegate {
  func didConfirm(data: TrackerCategory.Data) {
    viewModel.categoryProcessing(data: data)
    dismiss(animated: true)
  }
}

