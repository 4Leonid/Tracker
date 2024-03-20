//
//  CellBackgroundSettings.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class CellBackgroundSetting: UIView {
  
  // MARK: - Elements
  private let cellViewBoard: UIView = {
    let cellViewBoard = UIView()
    cellViewBoard.translatesAutoresizingMaskIntoConstraints = false
    cellViewBoard.backgroundColor = .yaGray
    cellViewBoard.isHidden = true
    return cellViewBoard
  }()
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Method
  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 16
    layer.masksToBounds = true
    backgroundColor = .yaBackground
    
    addSubview(cellViewBoard)
    
    NSLayoutConstraint.activate([
      cellViewBoard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      cellViewBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      cellViewBoard.bottomAnchor.constraint(equalTo: bottomAnchor),
      cellViewBoard.heightAnchor.constraint(equalToConstant: 0.5)
    ])
  }
  
  // MARK: - Configure Method for Corners & Cell Separator
  func configure(position: Position) {
    layer.cornerRadius = 16
    
    switch position {
    case .top:
      layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      cellViewBoard.isHidden = false
    case .middle:
      layer.cornerRadius = 0
      cellViewBoard.isHidden = false
    case .bottom:
      layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    case .common:
      cellViewBoard.isHidden = true
      layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
  }
}

// MARK: - Extension (Enum)
extension CellBackgroundSetting {
  enum Position {
    case top, middle, bottom, common
  }
}

