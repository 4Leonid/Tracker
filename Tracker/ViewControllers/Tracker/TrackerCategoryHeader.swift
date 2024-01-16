//
//  TrackerCategoryHeader.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class TrackerCategoryHeader: UICollectionReusableView {
    
    // MARK: - Elements
    private lazy var titleCategory: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        title.textColor = .yaBlack
        return title
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
        applyConstraint()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout & Setting
    private func addSubView() {
        addSubview(titleCategory)
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            titleCategory.topAnchor.constraint(equalTo: topAnchor),
            titleCategory.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleCategory.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
    // MARK: - Methods
    func configure(title: String) {
        titleCategory.text = title
    }
}

