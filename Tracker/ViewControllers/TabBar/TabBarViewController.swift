//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Леонид Турко on 28.12.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarItems()
    }
    
    // MARK: - Constructor Method
    private func setupBarItems() {
        tabBar.backgroundColor = .yaWhite
        tabBar.tintColor = .yaBlue
        tabBar.barTintColor = .yaGray
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowRadius = 0
        
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackerImage"),
            selectedImage: nil
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statisticImage"),
            selectedImage: nil
        )
        viewControllers = [trackerViewController, statisticViewController]
    }
}
