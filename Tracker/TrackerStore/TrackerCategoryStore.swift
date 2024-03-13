//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Леонид Турко on 07.02.2024.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
  func didUpdateCategory()
}

final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
  
  // MARK: - Properties
  weak var delegate: TrackerCategoryStoreDelegate?
  var category = [TrackerCategory]()
  var categoriesCD: [TrackerCategoryCoreData] {
    fetchedResultController.fetchedObjects ?? []
  }
  private let context: NSManagedObjectContext
  
  private lazy var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData> = {
    let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \TrackerCategoryCoreData.createdAt, ascending: true)
    ]
    let fetchedResultController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil)
    fetchedResultController.delegate = self
    try? fetchedResultController.performFetch()
    return fetchedResultController
  }()
  
  // MARK: - Initializers
  convenience override init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Error AppDelegate")
    }
    let context = appDelegate.persistentContainer.viewContext
    do {
      try self.init(context: context)
    } catch {
      fatalError("Failed to initialize with error: \(Error.self)")
    }
  }
  
  init(context: NSManagedObjectContext) throws {
    self.context = context
    super.init()
  }
  
  // MARK: - Methods
  func takeCategory(with id: UUID) throws -> TrackerCategoryCoreData {
    let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    request.predicate = NSPredicate(
      format: "%K == %@",
      #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
    let category = try context.fetch(request)
    return category[0]
  }
  
  func createCategoryForTrackers(from data: TrackerCategoryCoreData) throws -> TrackerCategory {
    guard let name = data.name,
          let stringID = data.categoryId,
          let id = UUID(uuidString: stringID) else { throw TrackerError.decodeError }
    return TrackerCategory(name: name, id: id)
  }
  
  func updateCategory(with data: TrackerCategory.Data) throws {
    let category = try getCategory(with: data.id)
    category.name = data.name
    try context.save()
  }
  
  func deleteCategory(category: TrackerCategory) throws {
    let deleteCategory = try getCategory(with: category.id)
    context.delete(deleteCategory)
  }
  
  @discardableResult
  func setupCategory(with name: String) throws -> TrackerCategory {
    let category = TrackerCategory(name: name)
    let cd = TrackerCategoryCoreData(context: context)
    cd.categoryId = category.id.uuidString
    cd.createdAt = Date()
    cd.name = category.name
    try context.save()
    return category
  }
  
  private func getCategory(with id: UUID) throws -> TrackerCategoryCoreData {
    fetchedResultController.fetchRequest.predicate = NSPredicate(
      format: "%K == %@",
      #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
    try fetchedResultController.performFetch()
    guard let category = fetchedResultController.fetchedObjects?.first else { throw TrackerError.decodeError }
    fetchedResultController.fetchRequest.predicate = nil
    try fetchedResultController.performFetch()
    return category
  }
  
  
  // MARK: - FetchResultDelegate
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.didUpdateCategory()
  }
}

