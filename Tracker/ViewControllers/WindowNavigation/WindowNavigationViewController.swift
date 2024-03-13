//
//  WindowNavigationViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import UIKit

final class WindowNavigationViewController: UIViewController {
  
  // MARK: - Properties
  @UserDefaultsBacked(key: "isOnboardingShown")
  private var isOnboardingShown: Bool?
  
  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if isOnboardingShown == true {
      showTabBarViewController()
    } else {
      showOnboardingViewController()
      isOnboardingShown = true
    }
  }
  
  // MARK: - Methods
  private func showOnboardingViewController() {
    let onboardingViewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    UIApplication.shared.windows.first?.rootViewController = onboardingViewController
  }
  
  private func showTabBarViewController() {
    let tabBarViewController = TabBarViewController()
    UIApplication.shared.windows.first?.rootViewController = tabBarViewController
  }
}

