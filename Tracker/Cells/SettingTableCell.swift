//
//  SettingTableCell.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class SettingTableCell: UITableViewCell {
  
  // MARK: - Elements
  private lazy var cellView = CellBackgroundSetting()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .yaBlack
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .yaGray
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "arrowRight"), for: .normal)
    button.isEnabled = false
    return button
  }()
  
  private let labelStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.spacing = 2
    stack.axis = .vertical
    return stack
  }()
  
  // MARK: - Identifier
  static let identifier = "TableCell"
  
  // MARK: - Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubViews()
    applyConstraint()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  func configure(name: String, description: String?, position: CellBackgroundSetting.Position) {
    nameLabel.text = name
    cellView.configure(position: position)
    
    if let description {
      descriptionLabel.text = description
    }
  }
  
}

// MARK: - Extension (Layout & Setting)
private extension SettingTableCell {
  
  func addSubViews() {
    contentView.addSubview(cellView)
    contentView.addSubview(labelStack)
    labelStack.addArrangedSubview(nameLabel)
    labelStack.addArrangedSubview(descriptionLabel)
    contentView.addSubview(button)
  }
  
  func applyConstraint() {
    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      labelStack.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      labelStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
      labelStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -56),
      button.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      button.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
    ])
  }
}

