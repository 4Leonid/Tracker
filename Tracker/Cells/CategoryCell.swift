//
//  CategoryCell.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import UIKit

final class CategoryCell: UITableViewCell {
  
  // MARK: - Identifier
  static let identifier = "TableCell"
  
  // MARK: - Elements
  private lazy var cellView = CellBackgroundSetting()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .yaBlack
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  private lazy var categoryMark: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "checkmark")
    return imageView
  }()
  
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
  func configure(name: String, isActive: Bool, position: CellBackgroundSetting.Position) {
    nameLabel.text = name
    categoryMark.isHidden = !isActive
    cellView.configure(position: position)
  }
}

// MARK: - Extension (Layout & Setting)
private extension CategoryCell {
  func addSubViews() {
    [cellView, nameLabel, categoryMark].forEach { contentView.addSubview($0) }
  }
  
  func applyConstraint() {
    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -41),
      categoryMark.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      categoryMark.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
    ])
  }
}

