//
//  TextFieldSettings.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class TextFieldSetting: UITextField {
    
    // MARK: - Properties
    private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    
    // MARK: - Initializer
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    // MARK: - Methods
    private func setupTextField(placeholder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
        backgroundColor = .yaBackground
        layer.cornerRadius = 16
        autocorrectionType = .yes
        self.placeholder = placeholder
    }
}


