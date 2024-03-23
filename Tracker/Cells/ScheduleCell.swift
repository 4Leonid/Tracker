//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
  func didToggleSwitch(days: WeekDays, active: Bool)
}

final class ScheduleCell: UITableViewCell {
  
  // MARK: - Elements
  private lazy var cellView = CellBackgroundSetting()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    label.textColor = .yaBlack
    return label
  }()
  
  private lazy var switchToggle: UISwitch = {
    let switchToggle = UISwitch()
    switchToggle.translatesAutoresizingMaskIntoConstraints = false
    switchToggle.onTintColor = .yaBlue
    switchToggle.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
    return switchToggle
  }()
  
  // MARK: - Properties
  weak var delegate: ScheduleCellDelegate?
  private var days: WeekDays?
  
  // MARK: - Identifier
  static let identifier = "ScheduleCell"
  
  // MARK: - Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubView()
    applyConstraint()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Actions
  @objc private func didToggleSwitch(_ sender: UISwitch) {
    guard let days = days else { return }
    delegate?.didToggleSwitch(days: days, active: sender.isOn)
  }
  
  // MARK: - Methods
  func configure(days: WeekDays, active: Bool, position: CellBackgroundSetting.Position) {
    self.days = days
    cellView.configure(position: position)
    nameLabel.text = days.fullForm
    switchToggle.isOn = active
  }
}

// MARK: - Extension (Layout & Setting)
private extension ScheduleCell {
  
  func addSubView() {
    contentView.addSubview(cellView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(switchToggle)
  }
  
  func applyConstraint() {
    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      nameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -83),
      switchToggle.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      switchToggle.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
    ])
  }
}


