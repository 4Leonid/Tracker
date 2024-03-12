//
//  OnboardingSinglePageViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import UIKit

final class OnboardingSinglePageViewController: UIViewController {
  
  // MARK: - Elements
  lazy var onboardImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  lazy var textLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubView()
    applyConstraint()
  }
  
  // MARK: - Layout & Setting
  private func addSubView() {
    [onboardImage, textLabel].forEach { view.addSubview($0) }
  }
  
  private func applyConstraint() {
    NSLayoutConstraint.activate([
      onboardImage.topAnchor.constraint(equalTo: view.topAnchor),
      onboardImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      onboardImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      onboardImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      textLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 22)
    ])
  }
}

