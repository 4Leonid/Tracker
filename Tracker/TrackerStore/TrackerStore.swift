//
//  TrackerStore.swift
//  Tracker
//
//  Created by Леонид Турко on 07.02.2024.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
  func didUpdate()
}

protocol TrackerStoreProtocol {
  var trackersCount: Int { get }
  var numberOfSections: Int { get }
  func numberOfRowsInSection(_ section: Int) -> Int
  func object(at indexPath: IndexPath) -> Tracker?
  func addTracker(tracker: Tracker, category: TrackerCategory) throws
  func headerInSection(_ section: Int) -> String?
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
  
  // MARK: - Properties
  weak var delegate: TrackerStoreDelegate?
  private let context: NSManagedObjectContext
  private let trackerCategoryStore = TrackerCategoryStore()
  
  private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
    let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.category?.categoryId, ascending: true), NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)]
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: "category",
      cacheName: nil)
    fetchedResultsController.delegate = self
    try? fetchedResultsController.performFetch()
    return fetchedResultsController
  }()
  
  // MARK: - Initializers
  convenience override init() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    self.init(context: context)
  }
  
  init(context: NSManagedObjectContext) {
    self.context = context
    super.init()
  }
  
  // MARK: - Methods
  func createTracker(from tracker: TrackerCoreData) throws -> Tracker {
    guard
      let stringID = tracker.trackerId,
      let id = UUID(uuidString: stringID),
      let name = tracker.name,
      let emoji = tracker.emoji,
      let colorHEX = tracker.color,
      let daysCount = tracker.record
    else { throw TrackerError.decodeError }
    let color = UIColorConvert.convertStringToColor(hex: colorHEX)
    let sked = WeekDays.reversTransformedSked(value: tracker.sked)
    return Tracker(id: id, name: name, color: color!, emoji: emoji, sked: sked, daysCount: daysCount.count)
  }
  
  func currentlyTrackers(date: Date, searchString: String) throws {
    
    let day = Calendar.current.component(.weekday, from: date)
    let weekdayIndex = day > 1 ? day - 2 : day + 5
    var matching = ""
    for index in 0..<7 {
      if index == weekdayIndex {
        matching += "1"
      } else {
        matching += "."
      }
    }
    var predicates = [NSPredicate]()
    predicates.append(NSPredicate(
      format: "%K == nil OR (%K != nil AND %K MATCHES[c] %@)",
      #keyPath(TrackerCoreData.sked),
      #keyPath(TrackerCoreData.sked),
      #keyPath(TrackerCoreData.sked), matching
    ))
    if !searchString.isEmpty {
      predicates.append(NSPredicate(
        format: "%K CONTAINS[cd] %@",
        #keyPath(TrackerCoreData.name), searchString
      ))
    }
    fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    try fetchedResultsController.performFetch()
    delegate?.didUpdate()
  }
  
  func takeTracker(for id: UUID) throws -> TrackerCoreData? {
    fetchedResultsController.fetchRequest.predicate = NSPredicate(
      format: "%K == %@",
      #keyPath(TrackerCoreData.trackerId), id.uuidString)
    try fetchedResultsController.performFetch()
    return fetchedResultsController.fetchedObjects?.first
  }
  
  // MARK: - FetchResultDelegate
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.didUpdate()
  }
}

// MARK: - Extension TrackerStoreProtocol
extension TrackerStore: TrackerStoreProtocol {
  var trackersCount: Int {
    fetchedResultsController.fetchedObjects?.count ?? 0
  }
  var numberOfSections: Int {
    fetchedResultsController.sections?.count ?? 0
  }
  
  func numberOfRowsInSection(_ section: Int) -> Int {
    fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func object(at indexPath: IndexPath) -> Tracker? {
    let cd = fetchedResultsController.object(at: indexPath)
    return try? createTracker(from: cd)
  }
  
  func addTracker(tracker: Tracker, category: TrackerCategory) throws {
    let trackerData = TrackerCoreData(context: context)
    let categoryData = try trackerCategoryStore.takeCategory(with: category.id)
    trackerData.trackerId = tracker.id.uuidString
    trackerData.createdAt = Date()
    trackerData.name = tracker.name
    trackerData.emoji = tracker.emoji
    trackerData.color = UIColorConvert.convertColorToString(color: tracker.color)
    trackerData.sked = WeekDays.transformedSked(value: tracker.sked)
    trackerData.category = categoryData
    try context.save()
  }
  
  func headerInSection(_ section: Int) -> String? {
    guard let cd = fetchedResultsController.sections?[section].objects?.first
            as? TrackerCoreData else { return nil }
    return cd.category?.name ?? nil
  }
  
}

// MARK: - ErrorCaseForStore
enum TrackerError: Error {
  case decodeError
}
