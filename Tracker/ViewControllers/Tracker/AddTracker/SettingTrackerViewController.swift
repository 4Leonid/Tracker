//
//  SettingTrackerViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

protocol SettingTrackerViewControllerDelegate: AnyObject {
  func didTapCancelButton()
  func didTapCreateButton(category: TrackerCategory, tracker: Tracker)
  func didUpdateTracker(with data: Tracker.Data)
}

final class SettingTrackerViewController: UIViewController {
  
  // MARK: - Elements
  private lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    return scroll
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var nameTracker: UITextField = {
    let nameTracker = TextFieldSetting(placeholder: "settingTrackerVC_nameTrackerPlaceholder".localized)
    nameTracker.addTarget(self, action: #selector(didChangeTextOnNameTracker), for: .editingChanged)
    return nameTracker
  }()
  
  private lazy var limitMessage: UILabel = {
    let limit = UILabel()
    limit.translatesAutoresizingMaskIntoConstraints = false
    limit.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    limit.textColor = .yaRed
    limit.text = "settingTrackerVC_limitMessage".localized
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
  
  private lazy var emojiCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .yaWhite
    collectionView.allowsMultipleSelection = false
    collectionView.isScrollEnabled = false
    collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
    collectionView.register(TrackerCategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    return collectionView
  }()
  
  private lazy var colorCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .yaWhite
    collectionView.allowsMultipleSelection = false
    collectionView.isScrollEnabled = false
    collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
    collectionView.register(TrackerCategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    return collectionView
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    button.setTitle("settingTrackerVC_cancelButton".localized, for: .normal)
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
    button.setTitle("settingTrackerVC_createButton".localized, for: .normal)
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
  private let setAction: SetAction
  private let trackerCategoryStore = TrackerCategoryStore()
  private var data: Tracker.Data {
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
    if sked.count == 7 { return "settingTrackerVC_skedString".localized }
    let short: [String] = sked.map { $0.shortcut }
    return short.joined(separator: ", ")
  }
  
  private let parametres = [
    "settingTrackerVC_categoryParamLabel".localized,
    "settingTrackerVC_skedParamLabel".localized
  ]
  private let emoji = [
    "🙂", "😻", "🌺", "🐶", "❤️", "😱",
    "😇", "😡", "🥶", "🤔", "🙌", "🍔",
    "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
  ]
  private let trackerColors = UIColor.trackerColors
  private let geomentricParams = UICollectionView.GeometricParams(
    cellCount: 6,
    leftInset: 18,
    rightInset: 19,
    cellSpacing: 5)
  private var messageHeightConstraint: NSLayoutConstraint?
  private var optionsTopConstraint: NSLayoutConstraint?
  
  // MARK: - Initializers
  init(version: CreatingTrackerViewController.TrackerVersion,actionType: SettingTrackerViewController.SetAction, data: Tracker.Data?) {
    self.version = version
    self.setAction = actionType
    self.data = data ?? Tracker.Data()
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
    setupDelegates()
    addSubViews()
    setTitle()
    applyConstraint()
    checkButtonValidation()
  }
  
  // MARK: - Layout & Setting
  private func addSubViews() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(nameTracker)
    contentView.addSubview(limitMessage)
    contentView.addSubview(optionsTableView)
    contentView.addSubview(emojiCollectionView)
    contentView.addSubview(colorCollectionView)
    contentView.addSubview(buttonStack)
    buttonStack.addArrangedSubview(cancelButton)
    buttonStack.addArrangedSubview(createButton)
  }
  
  private func applyConstraint() {
    
    messageHeightConstraint = limitMessage.heightAnchor.constraint(equalToConstant: 0)
    messageHeightConstraint?.isActive = true
    optionsTopConstraint = optionsTableView.topAnchor.constraint(equalTo: limitMessage.bottomAnchor, constant: 16)
    optionsTopConstraint?.isActive = true
    
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
      nameTracker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
      nameTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nameTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      nameTracker.heightAnchor.constraint(equalToConstant: 75),
      limitMessage.centerXAnchor.constraint(equalTo: nameTracker.centerXAnchor),
      limitMessage.topAnchor.constraint(equalTo: nameTracker.bottomAnchor, constant: 8),
      optionsTableView.heightAnchor.constraint(equalToConstant: data.sked != nil ? 150 : 75),
      optionsTableView.leadingAnchor.constraint(equalTo: nameTracker.leadingAnchor),
      optionsTableView.trailingAnchor.constraint(equalTo: nameTracker.trailingAnchor),
      emojiCollectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
      emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
      colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
      colorCollectionView.leadingAnchor.constraint(equalTo: emojiCollectionView.leadingAnchor),
      colorCollectionView.trailingAnchor.constraint(equalTo: emojiCollectionView.trailingAnchor),
      colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
      buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      buttonStack.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
      buttonStack.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  private func setTitle() {
    switch setAction {
    case .add:
      switch version {
      case .habit:
        title = "creatingVC_HabitTitle".localized
      case .event:
        title = "creatingVC_IrregularTitle".localized
      }
    case .edit:
      title = "settingTrackerVC_editTrackerTitle".localized
      nameTracker.text = data.name
    }
  }
  
  private func setupDelegates() {
    nameTracker.delegate = self
    optionsTableView.dataSource = self
    optionsTableView.delegate = self
    emojiCollectionView.dataSource = self
    emojiCollectionView.delegate = self
    colorCollectionView.dataSource = self
    colorCollectionView.delegate = self
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
    switch setAction {
    case .add:
      addTracker()
    case .edit:
      editTracker()
    }
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
    if data.category == nil {
      buttonIsEnable = false
      return
    }
    if data.emoji == nil {
      buttonIsEnable = false
      return
    }
    if data.color == nil {
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
  
  private func addTracker() {
    guard
      let category = data.category,
      let emoji = data.emoji,
      let color = data.color
    else { return }
    let createNewTracker = Tracker(name: data.name, color: color, emoji: emoji, sked: data.sked, daysCount: 0, attach: false, category: category)
    delegate?.didTapCreateButton(category: category, tracker: createNewTracker)
  }
  
  private func editTracker() {
    delegate?.didUpdateTracker(with: data)
  }
}

// MARK: - Extension Table DataSource
extension SettingTrackerViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.sked == nil ? 1 : 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableCell.identifier) as? SettingTableCell else { return UITableViewCell() }
    
    var description: String? = nil
    var position: CellBackgroundSetting.Position
    
    if data.sked == nil {
      description = data.category?.name
      position = .common
    } else {
      description = indexPath.row == 0 ? data.category?.name : skedString
      position = indexPath.row == 0 ? .top : .bottom
    }
    cell.configure(name: parametres[indexPath.row], description: description, position: position)
    return cell
  }
}

// MARK: - Extension Table Delegate
extension SettingTrackerViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      let categoryVC = CategoryViewController(category: data.category)
      categoryVC.delegate = self
      let navigationController = UINavigationController(rootViewController: categoryVC)
      present(navigationController, animated: true)
    case 1:
      guard let sked = data.sked else { return }
      let skedViewController = ScheduleViewController(markedWeekdays: sked)
      skedViewController.delegate = self
      let navigationController = UINavigationController(rootViewController: skedViewController)
      present(navigationController, animated: true)
    default:
      return
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
}

// MARK: - Extension CollectionView DataSource
extension SettingTrackerViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case emojiCollectionView:
      return emoji.count
    case colorCollectionView:
      return trackerColors.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case emojiCollectionView:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else {return UICollectionViewCell() }
      let emoji = emoji[indexPath.row]
      cell.configure(with: emoji)
      if emoji == data.emoji {
        cell.select()
        emojiCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
      }
      return cell
    case colorCollectionView:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
      let color = trackerColors[indexPath.row]
      cell.configure(with: color)
      if
        let colorCD = data.color,
        UIColorConvert.convertColorToString(color: color) ==
          UIColorConvert.convertColorToString(color: colorCD) {
        cell.select()
        colorCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
      }
      return cell
    default:
      return UICollectionViewCell()
    }
  }
}

// MARK: - Extension CollectionView Delegate
extension SettingTrackerViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CellSelectionProtocol else { return }
    switch collectionView {
    case emojiCollectionView:
      data.emoji = emoji[indexPath.row]
    case colorCollectionView:
      data.color = trackerColors[indexPath.row]
    default:
      break
    }
    cell.select()
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CellSelectionProtocol else { return }
    cell.deselect()
  }
}

// MARK: - Extension CollectionView Delegate FlowLayout
extension SettingTrackerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 24, left: geomentricParams.leftInset, bottom: 24, right: geomentricParams.rightInset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let availableSpace = collectionView.frame.width - geomentricParams.paddingWidth
    let cellWidth = availableSpace / CGFloat(geomentricParams.cellCount)
    return CGSize(width: cellWidth, height: 52)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    geomentricParams.cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard
      kind == UICollectionView.elementKindSectionHeader,
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerCategoryHeader else { return UICollectionReusableView() }
    var label: String
    switch collectionView {
    case emojiCollectionView:
      label = "settingTrackerVC_emojiTitle".localized
    case colorCollectionView:
      label = "settingTrackerVC_colorTitle".localized
    default:
      label = ""
    }
    view.configure(title: label)
    return view
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let indexPath = IndexPath(row: 0, section: section)
    let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
    return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
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

extension SettingTrackerViewController: CategoryViewControllerDelegate {
  func didConfirm(category: TrackerCategory) {
    data.category = category
    optionsTableView.reloadData()
    dismiss(animated: true)
  }
}

// MARK: - Extension TextField
extension SettingTrackerViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    nameTracker.resignFirstResponder()
    return true
  }
}

// MARK: - Enum Action
extension SettingTrackerViewController {
  enum SetAction {
    case add, edit
  }
}



