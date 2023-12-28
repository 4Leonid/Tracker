//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Elements
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Статистика"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .yaBlack
        return titleLabel
    }()
    
    // MARK: - Properties
    private let statisticPlaceholder = UIStackView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yaWhite
        addSubView()
        applyConstraint()
        statisticPlaceholder.configure(name: "cryPlaceholder", text: "Анализировать пока нечего")
    }
    
    // MARK: - Layout & Setting
    private func addSubView() {
        view.addSubview(titleLabel)
        view.addSubview(statisticPlaceholder)
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticPlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statisticPlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

