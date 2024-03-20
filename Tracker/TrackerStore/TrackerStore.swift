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
  var delegate: TrackerStoreDelegate? { get set }
  func numberOfRowsInSection(_ section: Int) -> Int
  func object(at indexPath: IndexPath) -> Tracker?
  func addTracker(tracker: Tracker, category: TrackerCategory) throws
  func headerInSection(_ section: Int) -> String?
  func currentlyTrackers(date: Date, searchString: String, filter: Filter) throws
  func deleteTracker(tracker: Tracker) throws
  func editTracker(tracker: Tracker, data: Tracker.Data) throws
  func turnAttach(tracker: Tracker) throws
  func takeTrackersForFilter(date: Date) throws
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
  
  // MARK: - Properties
  weak var delegate: TrackerStoreDelegate?
  private let context: NSManagedObjectContext
  private let trackerCategoryStore = TrackerCategoryStore()
  
  private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
    let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.category?.createdAt, ascending: true), NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)]
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
      let daysCount = tracker.record,
      let categoryData = tracker.category,
      let category = try? trackerCategoryStore.createCategoryForTrackers(from: categoryData)
    else { throw TrackerError.decodeError }
    let color = UIColorConvert.convertStringToColor(hex: colorHEX)
    let sked = WeekDays.reversTransformedSked(value: tracker.sked)
    return Tracker(id: id, name: name, color: color!, emoji: emoji, sked: sked, daysCount: daysCount.count, attach: tracker.attach, category: category)
  }
  
  func currentlyTrackers(date: Date, searchString: String, filter: Filter) throws {
    
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
        format: "%K CONTAINS[cdx] %@",
        #keyPath(TrackerCoreData.name), searchString
      ))
    }
    
    if filter == .unfinished {
      fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(record.date == nil OR record.date != %@) AND (record.completed == %@ OR record.completed == nil)", date as NSDate, NSNumber(value: false))
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
    guard let track = fetchedResultsController.fetchedObjects?.first else { throw TrackerError.decodeError }
    fetchedResultsController.fetchRequest.predicate = nil
    try fetchedResultsController.performFetch()
    return track
  }
  
  func takeTrackersForFilter(date: Date) throws {
    let predicateFormat = "record.date CONTAINS %@"
    let request = TrackerCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    request.predicate = NSPredicate(format: predicateFormat, date as NSDate)
    fetchedResultsController.fetchRequest.predicate = request.predicate
    do {
      try fetchedResultsController.performFetch()
      delegate?.didUpdate()
    } catch {
      print("Error fetching completed trackers: \(error.localizedDescription)")
    }
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
    sections.count
  }
  
  private var isAttachTracker: [Tracker] {
    return fetchedResultsController.fetchedObjects?
      .compactMap { try? createTracker(from: $0) }
      .filter({ $0.attach }) ?? []
  }
  
  private var sections: [[Tracker]] {
    guard
      let sectionsData = fetchedResultsController.sections
    else { return [] }
    
    var sections: [[Tracker]] = []
    
    if !isAttachTracker.isEmpty {
      sections.append(isAttachTracker)
    }
    sectionsData.forEach { section in
      let addSection = section.objects?
        .compactMap { object -> Tracker? in
          guard
            let trackerData = object as? TrackerCoreData,
            let tracker = try? createTracker(from: trackerData),
            !isAttachTracker.contains(where: { $0.id == tracker.id })
          else { return nil }
          return tracker
        }
      if let addSection = addSection, !addSection.isEmpty {
        sections.append(addSection)
      }
    }
    return sections
  }
  
  func numberOfRowsInSection(_ section: Int) -> Int {
    sections[section].count
  }
  
  func object(at indexPath: IndexPath) -> Tracker? {
    let tracker = sections[indexPath.section][indexPath.item]
    return tracker
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
    trackerData.attach = tracker.attach
    try context.save()
  }
  
  func headerInSection(_ section: Int) -> String? {
    if !isAttachTracker.isEmpty && section == 0 {
      return "trackerStore_attach".localized
    }
    guard
      let category = sections[section].first?.category
    else  { return nil }
    return category.name
  }
  
  func deleteTracker(tracker: Tracker) throws {
    guard
      let trackerWillBeDelete = try takeTracker(for: tracker.id)
    else { throw TrackerError.decodeError }
    
    if let records = trackerWillBeDelete.record {
      for record in records {
        guard let record = record as? TrackerRecordCoreData else { continue }
        context.delete(record)
      }
    }
    context.delete(trackerWillBeDelete)
    try context.save()
  }
  
  func editTracker(tracker: Tracker, data: Tracker.Data) throws {
    guard
      let emoji = data.emoji,
      let color = data.color,
      let category = data.category
    else { return }
    let trackerData = try takeTracker(for: tracker.id)
    let categoryData = try trackerCategoryStore.takeCategory(with: category.id)
    trackerData?.name = data.name
    trackerData?.emoji = emoji
    trackerData?.color = UIColorConvert.convertColorToString(color: color)
    trackerData?.sked = WeekDays.transformedSked(value: data.sked)
    trackerData?.category = categoryData
    try context.save()
  }
  
  func turnAttach(tracker: Tracker) throws {
    guard
      let attachableTracker = try takeTracker(for: tracker.id)
    else { throw TrackerError.decodeError }
    attachableTracker.attach.toggle()
    try context.save()
  }
}

// MARK: - ErrorCaseForStore
enum TrackerError: Error {
  case decodeError
}
