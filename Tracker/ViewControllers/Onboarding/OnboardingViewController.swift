//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
  
  // MARK: - Elements
  private lazy var pages: [UIViewController] = {
    let firstOnboardingPage = OnboardingSinglePageViewController()
    firstOnboardingPage.onboardImage.image = UIImage(named: "onboardImageFirst")
    firstOnboardingPage.textLabel.text = "onboardingVC_firstPageText".localized
    
    let secondOnboardingPage = OnboardingSinglePageViewController()
    secondOnboardingPage.onboardImage.image = UIImage(named: "onboardImageSecond")
    secondOnboardingPage.textLabel.text = "onboardingVC_secondPageText".localized
    
    return [firstOnboardingPage, secondOnboardingPage]
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .black
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    button.setTitle("onboardingVC_button".localized, for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 16
    button.addTarget(nil, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }()
  
  private lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.numberOfPages = pages.count
    pageControl.currentPage = 0
    pageControl.currentPageIndicatorTintColor = .yaBlack
    return pageControl
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDelegates()
    addSubViews()
    applyConstraint()
  }
  
  // MARK: - Layout & Setting
  private func addSubViews() {
    [button, pageControl].forEach { view.addSubview($0) }
  }
  
  private func applyConstraint() {
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      button.heightAnchor.constraint(equalToConstant: 60),
      pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  private func setupDelegates() {
    dataSource = self
    delegate = self
    
    if let first = pages.first {
      setViewControllers([first], direction: .forward, animated: true)
    }
  }
}

// MARK: - Actions & Methods
extension OnboardingViewController {
  @objc private func didTapButton() {
    let tabBarViewController = TabBarViewController()
    tabBarViewController.modalPresentationStyle = .fullScreen
    present(tabBarViewController, animated: true)
  }
}

// MARK: - Extension DataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
    let previousIndex = vcIndex - 1
    guard previousIndex >= 0 else { return pages.last }
    return pages[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
    let nextIndex = vcIndex + 1
    guard nextIndex < pages.count else { return pages.first }
    return pages[nextIndex]
  }
}

// MARK: - Extension Delegate
extension OnboardingViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let currentViewController = pageViewController.viewControllers?.first,
       let currentIndex = pages.firstIndex(of: currentViewController) {
      pageControl.currentPage = currentIndex
    }
  }
}
