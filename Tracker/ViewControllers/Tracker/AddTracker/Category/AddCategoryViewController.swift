//
//  AddCategoryViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
  func didConfirm(data: TrackerCategory.Data)
}

final class AddCategoryViewController: UIViewController {
  
  // MARK: - Elements
  private lazy var textField: UITextField = {
    let textField = TextFieldSetting(placeholder: "addCategoryVC_nameCategoryPlaceholder".localized)
    textField.addTarget(self, action: #selector(didChangeTextCategory), for: .editingChanged)
    return textField
  }()
  
  private lazy var confirmButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .yaGray
    button.setTitleColor(.yaWhite, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.setTitle("addCategoryVC_confirmButtonText".localized, for: .normal)
    button.layer.cornerRadius = 16
    button.isEnabled = false
    button.addTarget(self, action: #selector(didTapRdyButton), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Properties
  weak var delegate: AddCategoryViewControllerDelegate?
  private var isEnableButton: Bool = false {
    willSet {
      confirmButton.backgroundColor = newValue ? .yaBlack : .yaGray
      confirmButton.isEnabled = newValue ? true : false
    }
  }
  private var data: TrackerCategory.Data
  
  // MARK: - Initializer
  init(data: TrackerCategory.Data = TrackerCategory.Data()) {
    self.data = data
    super.init(nibName: nil, bundle: nil)
    textField.text = data.name
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "addCategoryVC_title".localized
    view.backgroundColor = .yaWhite
    addSubViews()
    applyConstraint()
  }
  
  // MARK: - Layout & Setting
  private func addSubViews() {
    [textField, confirmButton].forEach { view.addSubview($0) }
  }
  
  private func applyConstraint() {
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      textField.heightAnchor.constraint(equalToConstant: 75),
      confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      confirmButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  // MARK: - Actions
  @objc private func didChangeTextCategory(_ sender: UITextField) {
    if let text = sender.text,
       !text.isEmpty {
      data.name = text
      isEnableButton = true
    } else {
      isEnableButton = false
    }
  }
  
  @objc private func didTapRdyButton() {
    delegate?.didConfirm(data: data)
  }
}

// MARK: - Extension TextField
extension AddCategoryViewController: UITextFieldDelegate {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

