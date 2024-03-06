//
//  ColorCell.swift
//  Tracker
//
//  Created by Леонид Турко on 16.01.2024.
//

import UIKit

final class ColorCell: UICollectionViewCell, CellSelectionProtocol {
  
  // MARK: - Identifier
  static let identifier = "ColorCell"
  
  // MARK: - Element
  private lazy var colorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 8
    return view
  }()
  
  // MARK: - Properties
  private var color: UIColor?
  
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
  
  func configure(with color: UIColor) {
    colorView.backgroundColor = color
    self.color = color
  }
  
  func select() {
    guard let color else { return }
    contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    contentView.layer.borderWidth = 3
  }
  
  func deselect() {
    contentView.layer.borderWidth = .zero
  }
}

// MARK: - Layout & Setting & Actions
private extension ColorCell {
  
  func addSubViews() {
    contentView.layer.cornerRadius = 8
    contentView.layer.masksToBounds = true
    contentView.addSubview(colorView)
  }
  
  func applyConstraint() {
    NSLayoutConstraint.activate([
      colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      colorView.widthAnchor.constraint(equalToConstant: 40),
      colorView.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}

