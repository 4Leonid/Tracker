//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didRdy(activeDays: [WeekDays])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Elements
    private lazy var weekdaysTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        return tableView
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = . yaBlack
        button.setTitleColor(.yaWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Готово", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapRdyButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: ScheduleViewControllerDelegate?
    private var markedWeekdays: Set<WeekDays> = []
    
    // MARK: - Initializers
    init(markedWeekdays: [WeekDays]) {
        super.init(nibName: nil, bundle: nil)
        self.markedWeekdays = Set(markedWeekdays)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .yaWhite
        setupDelegates()
        addSubView()
        applyConstraint()
    }
    
    // MARK: - Layout & Setting
    private func addSubView() {
        view.addSubview(weekdaysTableView)
        view.addSubview(readyButton)
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            weekdaysTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekdaysTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekdaysTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weekdaysTableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -47),
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupDelegates() {
        weekdaysTableView.dataSource = self
        weekdaysTableView.delegate = self
    }
}

// MARK: - Extension (actions & methods)
extension ScheduleViewController {
    @objc private func didTapRdyButton() {
        let days = Array(markedWeekdays).sorted { (day1, day2) -> Bool in
            guard let weekday1 = WeekDays.allCases.firstIndex(of: day1),
                  let weekday2 = WeekDays.allCases.firstIndex(of: day2) else { return false }
            return weekday1 < weekday2
        }
        delegate?.didRdy(activeDays: days)
    }
}

// MARK: - Extension DataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier) as? ScheduleCell else { return UITableViewCell() }
        
        var position: CellBackgroundSetting.Position
        let weekday = WeekDays.allCases[indexPath.row]
        
        // background view position setting
        switch indexPath.row {
        case 0:
            position = .top
        case 1...5:
            position = .middle
        case 6:
            position = .bottom
        default:
            position = .common
        }
        
        cell.configure(days: weekday, active: markedWeekdays.contains(weekday), position: position)
        cell.delegate = self
        return cell
    }
}

// MARK: - Extension Delegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - Extension Sked Cell
extension ScheduleViewController: ScheduleCellDelegate {
    func didToggleSwitch(days: WeekDays, active: Bool) {
        if active {
            markedWeekdays.insert(days)
        } else {
            markedWeekdays.remove(days)
        }
    }
}


