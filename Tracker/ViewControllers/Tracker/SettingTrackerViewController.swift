//
//  SettingTrackerViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

protocol SettingTrackerViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapCreateButton(category: String, tracker: Tracker)
}

final class SettingTrackerViewController: UIViewController {
    
    // MARK: - Elements
    private lazy var nameTracker: UITextField = {
        let nameTracker = TextFieldSetting(placeholder: "Введите название трекера")
        nameTracker.addTarget(self, action: #selector(didChangeTextOnNameTracker), for: .editingChanged)
        return nameTracker
    }()
    
    private lazy var limitMessage: UILabel = {
        let limit = UILabel()
        limit.translatesAutoresizingMaskIntoConstraints = false
        limit.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        limit.textColor = .yaRed
        limit.text = "Ограничение 38 символов"
        return limit
    }()
    
    private lazy var optionsTableView: UITableView = {
        let optionsTable = UITableView()
        optionsTable.translatesAutoresizingMaskIntoConstraints = false
        optionsTable.separatorStyle = .none
        optionsTable.isScrollEnabled = false
        optionsTable.register(SettingTableCell.self, forCellReuseIdentifier: SettingTableCell.identifier)
        return optionsTable
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.yaRed, for: .normal)
        button.backgroundColor = .yaWhite
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.yaRed.cgColor
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yaGray
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 8
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        return buttonStack
    }()
    
    // MARK: - Properties
    weak var delegate: SettingTrackerViewControllerDelegate?
    private let version: CreatingTrackerViewController.TrackerVersion
    private var data: Tracker.Track {
        didSet {
            checkButtonValidation()
        }
    }
    
    private var buttonIsEnable = false {
        willSet {
            if newValue {
                createButton.backgroundColor = .yaBlack
                createButton.setTitleColor(.yaWhite, for: .normal)
                createButton.isEnabled = true
            } else {
                createButton.backgroundColor = .yaGray
                createButton.setTitleColor(.white, for: .normal)
                createButton.isEnabled = false
            }
        }
    }
    
    private var limitMessageVisible = false {
        didSet {
            checkButtonValidation()
            if limitMessageVisible {
                messageHeightConstraint?.constant = 22
                optionsTopConstraint?.constant = 32
            } else {
                messageHeightConstraint?.constant = 0
                optionsTopConstraint?.constant = 16
            }
        }
    }
    
    private var skedString: String? {
        guard let sked = data.sked else { return nil }
        if sked.count == 7 { return "Каждый день" }
        let short: [String] = sked.map { $0.shortcut }
        return short.joined(separator: ", ")
    }
    
    private var category: String? = TrackerCategory.defaultValue[0].name {
        didSet {
            checkButtonValidation()
        }
    }
    
    private let parametres = ["Категория", "Расписание"]
    private let emoji = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
    ]
    private let trackerColors = UIColor.trackerColors
    
    private var messageHeightConstraint: NSLayoutConstraint?
    private var optionsTopConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    init(version: CreatingTrackerViewController.TrackerVersion, data: Tracker.Track = Tracker.Track()) {
        self.version = version
        self.data = data
        super.init(nibName: nil, bundle: nil)
        
        switch version {
        case .habit:
            self.data.sked = []
        case .event:
            self.data.sked = nil
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yaWhite
        nameTracker.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        addSubViews()
        setTitle()
        applyConstraint()
        checkButtonValidation()
        takeRandomElement()
    }
    
    // MARK: - Layout & Setting
    private func addSubViews() {
        view.addSubview(nameTracker)
        view.addSubview(limitMessage)
        view.addSubview(optionsTableView)
        view.addSubview(buttonStack)
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(createButton)
    }
    
    private func applyConstraint() {
        
        messageHeightConstraint = limitMessage.heightAnchor.constraint(equalToConstant: 0)
        messageHeightConstraint?.isActive = true
        optionsTopConstraint = optionsTableView.topAnchor.constraint(equalTo: limitMessage.bottomAnchor, constant: 16)
        optionsTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            nameTracker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTracker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTracker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTracker.heightAnchor.constraint(equalToConstant: 75),
            limitMessage.centerXAnchor.constraint(equalTo: nameTracker.centerXAnchor),
            limitMessage.topAnchor.constraint(equalTo: nameTracker.bottomAnchor, constant: 8),
            optionsTableView.heightAnchor.constraint(equalToConstant: title == "Новая привычка" ? 150 : 75),
            optionsTableView.leadingAnchor.constraint(equalTo: nameTracker.leadingAnchor),
            optionsTableView.trailingAnchor.constraint(equalTo: nameTracker.trailingAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setTitle() {
        switch version {
        case .habit:
            title = "Новая привычка"
        case .event:
            title = "Новое нерегулярное событие"
        }
    }
}

// MARK: - Extension (actions & methods)
extension SettingTrackerViewController {
    @objc private func didChangeTextOnNameTracker(_ sender: UITextField) {
        guard let text = sender.text else { return }
        data.name = text
        if text.count > 38 {
            limitMessageVisible = true
        } else {
            limitMessageVisible = false
        }
    }
    
    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    @objc private func didTapCreateButton() {
        guard let category = category,
              let emoji = data.emoji,
              let color = data.color else { return }
        let createNewTracker = Tracker(name: data.name, color: color, emoji: emoji, sked: data.sked)
        delegate?.didTapCreateButton(category: category, tracker: createNewTracker)
    }
    
    private func checkButtonValidation() {
        if data.name.count == 0 {
            buttonIsEnable = false
            return
        }
        if limitMessageVisible {
            buttonIsEnable = false
            return
        }
        if category == nil {
            buttonIsEnable = false
            return
        }
        if let sked = data.sked,
            sked.isEmpty {
            buttonIsEnable = false
            return
        }
        buttonIsEnable = true
    }
    
    private func takeRandomElement() {
        data.emoji = emoji.randomElement()
        data.color = trackerColors.randomElement()
    }
}

// MARK: - Extension DataSource
extension SettingTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.sked == nil ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableCell.identifier) as? SettingTableCell else { return UITableViewCell() }
        
        var description: String? = nil
        var position: CellBackgroundSetting.Position
        
        if data.sked == nil {
            description = category
            position = .common
        } else {
            description = indexPath.row == 0 ? category : skedString
            position = indexPath.row == 0 ? .top : .bottom
        }
        cell.configure(name: parametres[indexPath.row], description: description, position: position)
        return cell
    }
}

// MARK: - Extension Delegate
extension SettingTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            guard let sked = data.sked else { return }
            let skedViewController = ScheduleViewController(markedWeekdays: sked)
            skedViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: skedViewController)
            present(navigationController, animated: true)
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - Extension Sked
extension SettingTrackerViewController: ScheduleViewControllerDelegate {
    func didRdy(activeDays: [WeekDays]) {
        data.sked = activeDays
        optionsTableView.reloadData()
        dismiss(animated: true)
    }
}

extension SettingTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTracker.resignFirstResponder()
        return true
    }
}

