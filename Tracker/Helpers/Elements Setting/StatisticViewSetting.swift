//
//  StatisticViewSetting.swift
//  Tracker
//
//  Created by Леонид Турко on 18.03.2024.
//

import UIKit

final class StatisticViewSetting: UIView {
  
  // MARK: - Elements
  private let nameStatisticLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textColor = .yaBlack
    return label
  }()
  
  private let valueStatisticLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    label.textColor = .yaBlack
    return label
  }()
  
  // MARK: - Properties
  private var name: String {
    didSet {
      nameStatisticLabel.text = name
    }
  }
  
  private var value: Int {
    didSet {
      valueStatisticLabel.text = "\(value)"
    }
  }
  
  // MARK: - Initializer
  init(name: String, value: Int = 0) {
    self.name = name
    self.value = value
    super.init(frame: .zero)
    setup()
    config(name: name, value: value)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Override Method
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientBorder(
      width: 1,
      colors: [.grBlue, .grGreen, .grRed],
      startPoint: .unitCoordinate(.left),
      endPoint: .unitCoordinate(.right),
      andRoundCornersWithRadius: 16
    )
  }
  
  // MARK: - Public Method
  func config(name: String, value: Int) {
    self.name = name
    self.value = value
  }
  
  // MARK: - Private Method
  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(nameStatisticLabel)
    addSubview(valueStatisticLabel)
    
    NSLayoutConstraint.activate([
      valueStatisticLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      valueStatisticLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      valueStatisticLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      nameStatisticLabel.topAnchor.constraint(equalTo: valueStatisticLabel.bottomAnchor, constant: 7),
      nameStatisticLabel.leadingAnchor.constraint(equalTo: valueStatisticLabel.leadingAnchor),
      nameStatisticLabel.trailingAnchor.constraint(equalTo: valueStatisticLabel.trailingAnchor),
      nameStatisticLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
    ])
  }
}
