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
    firstOnboardingPage.textLabel.text = "Отслеживайте только то, что хотите"
    
    let secondOnboardingPage = OnboardingSinglePageViewController()
    secondOnboardingPage.onboardImage.image = UIImage(named: "onboardImageSecond")
    secondOnboardingPage.textLabel.text = "Даже если это не литры воды и йога"
    
    return [firstOnboardingPage, secondOnboardingPage]
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
    view.addSubview(pageControl)
  }
  
  private func applyConstraint() {
    NSLayoutConstraint.activate([
      pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
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
