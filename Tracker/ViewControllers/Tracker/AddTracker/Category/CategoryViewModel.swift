//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Леонид Турко on 12.03.2024.
//

import Foundation

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
  func didUpdateCategories()
  func didSelectCategory(category: TrackerCategory)
}

final class CategoryViewModel: TrackerCategoryStoreDelegate {
  
  // MARK: - Properties
  weak var delegate: CategoryViewModelDelegate?
  private let trackerCategoryStore = TrackerCategoryStore()
  private(set) var categories: [TrackerCategory] = [] {
    didSet {
      delegate?.didUpdateCategories()
    }
  }
  private(set) var selectedCategory: TrackerCategory? = nil {
    didSet {
      guard let selectedCategory else { return }
      delegate?.didSelectCategory(category: selectedCategory)
    }
  }
  
  // MARK: - Initializer
  init(selectedCategory: TrackerCategory?) {
    self.selectedCategory = selectedCategory
    trackerCategoryStore.delegate = self
  }
  
  // MARK: - CategoryStore Delegate
  func didUpdateCategory() {
    categories = takeCategories()
  }
  
  // MARK: - Methods
  func loadCategories() {
    categories = takeCategories()
  }
  
  func selectCategories(indexPath: IndexPath) {
    selectedCategory = categories[indexPath.row]
  }
  
  func deleteCategory(category: TrackerCategory) {
    do {
      try trackerCategoryStore.deleteCategory(category: category)
      loadCategories()
      if category == selectedCategory {
        selectedCategory = nil
      }
    } catch { }
  }
  
  func categoryProcessing(data: TrackerCategory.Data) {
    if categories.contains(where: { $0.id == data.id }) {
      updateCategory(data: data)
    } else {
      addCategory(name: data.name)
    }
  }
  
  private func takeCategories() -> [TrackerCategory] {
    do {
      let categories = try trackerCategoryStore.categoriesCD.map {
        try trackerCategoryStore.createCategoryForTrackers(from: $0)
      }
      return categories
    } catch {
      return []
    }
  }
  
  private func updateCategory(data: TrackerCategory.Data) {
    do {
      try trackerCategoryStore.updateCategory(with: data)
      loadCategories()
    } catch { }
  }
  
  private func addCategory(name: String) {
    do {
      try trackerCategoryStore.setupCategory(with: name)
      loadCategories()
    } catch { }
  }
}
