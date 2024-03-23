//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
  
  var statisticUpdate: (([TrackerRecord]) -> Void)?
  
  // MARK: - Elements
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "statisticVC_title".localized
    titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    titleLabel.textColor = .yaBlack
    return titleLabel
  }()
  
  private let statisticStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    return stackView
  }()
  
  private let statisticPlaceholder = UIStackView()
  
  // MARK: - Properties
  private let trackersCompleted = StatisticViewSetting(name: "statisticVC_trackersCompleted".localized)
  private let trackerStore = TrackerStore()
  private let trackerRecordStore = TrackerRecordStore()
  private var trackerRecord: [TrackerRecord] = [] {
    didSet {
      let uniqueTrackers = Set(trackerRecord)
      statisticUpdate?(Array(uniqueTrackers))
    }
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yaWhite
    addSubView()
    applyConstraint()
    statisticPlaceholder.configure(name: "cryPlaceholder", text: "statisticVC_placeholderText".localized)
    statisticUpdate = { [weak self] trackers in
      guard let self else { return }
      self.placeholderAndStackViewHiddenCheck()
      self.updateValue(with: trackers.count)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTrackerRecord()
  }
  
  // MARK: - Methods
  private func placeholderAndStackViewHiddenCheck() {
    let isHidden = trackerStore.trackersCount == 0
    statisticPlaceholder.isHidden = !isHidden
    statisticStackView.isHidden = isHidden
  }
  
  private func updateTrackerRecord() {
    guard
      let trackerRecord = try? trackerRecordStore.takeCompletedTrackersForStatistic()
    else { return }
    self.trackerRecord = trackerRecord
  }
  
  private func updateValue(with value: Int) {
    trackersCompleted.config(name: "statisticVC_trackersCompleted".localized, value: value)
  }
  
  
  // MARK: - Layout & Setting
  private func addSubView() {
    view.addSubview(titleLabel)
    view.addSubview(statisticPlaceholder)
    view.addSubview(statisticStackView)
    statisticStackView.addArrangedSubview(trackersCompleted)
  }
  
  private func applyConstraint() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      statisticPlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      statisticPlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      statisticStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      statisticStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      statisticStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77)
    ])
  }
}

