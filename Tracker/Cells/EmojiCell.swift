//
//  EmojiCell.swift
//  Tracker
//
//  Created by Леонид Турко on 16.01.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell, CellSelectionProtocol {
  
  // MARK: - Identifier
  static let identifier = "EmojiCell"
  
  // MARK: - Element
  private lazy var emoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    return label
  }()
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubViews()
    applyConstraint()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  func configure(with text: String) {
    emoLabel.text = text
  }
  
  func select() {
    contentView.backgroundColor = .yaLightGray
  }
  
  func deselect() {
    contentView.backgroundColor = .clear
  }
}

// MARK: - Layout & Setting & Actions
private extension EmojiCell {
  
  func addSubViews() {
    contentView.layer.cornerRadius = 16
    contentView.layer.masksToBounds = true
    contentView.addSubview(emoLabel)
  }
  
  func applyConstraint() {
    NSLayoutConstraint.activate([
      emoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      emoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}

