//
//  TrackerCell.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
  func didTapExecButton(cell: TrackerCell, with tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
  
  // MARK: - Elements
  private let cardView: UIView = {
    let cardView = UIView()
    cardView.translatesAutoresizingMaskIntoConstraints = false
    cardView.layer.borderWidth = 1
    cardView.layer.borderColor = UIColor(red: 0xAE/255.0, green: 0xAF/255.0, blue: 0xB4/255.0, alpha: 0.3).cgColor
    cardView.layer.cornerRadius = 16
    return cardView
  }()
  
  private let emojiView: UIView = {
    let emojiView = UIView()
    emojiView.translatesAutoresizingMaskIntoConstraints = false
    emojiView.layer.cornerRadius = 12
    emojiView.backgroundColor = UIColor(red: 0xFF/255.0, green: 0xFF/255.0, blue: 0xFF/255.0, alpha: 0.2)
    return emojiView
  }()
  
  private let emojiLabel: UILabel = {
    let emojiLabel = UILabel()
    emojiLabel.font = UIFont.systemFont(ofSize: 16)
    emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    return emojiLabel
  }()
  
  private let trackerLabel: UILabel = {
    let trackerLabel = UILabel()
    trackerLabel.translatesAutoresizingMaskIntoConstraints = false
    trackerLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    trackerLabel.textColor = UIColor.white
    trackerLabel.numberOfLines = 0
    return trackerLabel
  }()
  
  private let daysLabel: UILabel = {
    let daysLabel = UILabel()
    daysLabel.translatesAutoresizingMaskIntoConstraints = false
    daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    daysLabel.textColor = .yaBlack
    return daysLabel
  }()
  
  private lazy var execButton: UIButton = {
    let execButton = UIButton()
    execButton.translatesAutoresizingMaskIntoConstraints = false
    execButton.setImage(UIImage(systemName: "plus"), for: .normal)
    execButton.tintColor = .yaWhite
    execButton.layer.cornerRadius = 17
    execButton.addTarget(self, action: #selector(didTapExecButton), for: .touchUpInside)
    return execButton
  }()
  
  // MARK: - Properties
  weak var delegate: TrackerCellDelegate?
  private var tracker: Tracker?
  private var daysCount = 0 {
    willSet {
      daysLabel.text = newValue.daysString()
    }
  }
  
  // MARK: - Identifier
  static let identifier = "TrackerCell"
  
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
  override func prepareForReuse() {
    super.prepareForReuse()
    tracker = nil
    daysCount = 0
    execButton.setImage(UIImage(systemName: "plus"), for: .normal)
    execButton.layer.opacity = 1
  }
  
  func configure(with tracker: Tracker, days: Int, active: Bool) {
    self.tracker = tracker
    self.daysCount = days
    cardView.backgroundColor = tracker.color
    emojiLabel.text = tracker.emoji
    trackerLabel.text = tracker.name
    execButton.backgroundColor = tracker.color
    changeImageButton(active: active)
  }
  
  func changeImageButton(active: Bool) {
    if active {
      execButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
      execButton.layer.opacity = 0.3
    } else {
      execButton.setImage(UIImage(systemName: "plus"), for: .normal)
      execButton.layer.opacity = 1
    }
  }
  
  func addOrSubtrack(value: Bool) {
    if value == true {
      daysCount += 1
    } else {
      daysCount -= 1
    }
  }
}

// MARK: - Layout & Setting & Actions
private extension TrackerCell {
  
  @objc func didTapExecButton() {
    guard let tracker else { return }
    delegate?.didTapExecButton(cell: self, with: tracker)
  }
  
  func addSubViews() {
    contentView.addSubview(cardView)
    contentView.addSubview(emojiView)
    contentView.addSubview(emojiLabel)
    contentView.addSubview(trackerLabel)
    contentView.addSubview(daysLabel)
    contentView.addSubview(execButton)
  }
  
  func applyConstraint() {
    NSLayoutConstraint.activate([
      cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cardView.heightAnchor.constraint(equalToConstant: 90),
      emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
      emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
      emojiView.widthAnchor.constraint(equalToConstant: 24),
      emojiView.heightAnchor.constraint(equalToConstant: 24),
      emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
      emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
      trackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
      trackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
      trackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 12),
      daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
      daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      execButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
      execButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      execButton.widthAnchor.constraint(equalToConstant: 34),
      execButton.heightAnchor.constraint(equalToConstant: 34)
    ])
  }
}
