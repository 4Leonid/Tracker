//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Леонид Турко on 07.02.2024.
//

import CoreData
import UIKit

protocol TrackerRecordStoreDelegate: AnyObject {
  func didUpdateRecord(records: Set<TrackerRecord>)
}

final class TrackerRecordStore: NSObject {
  
  // MARK: - Properties
  weak var delegate: TrackerRecordStoreDelegate?
  private let context: NSManagedObjectContext
  private let trackerStore = TrackerStore()
  private var completedTrackers: Set<TrackerRecord> = []
  
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
  func takeCompletedTrackers(with date: Date) throws {
    let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    request.returnsObjectsAsFaults = false
    request.predicate = NSPredicate(
      format: "%K == %@",
      #keyPath(TrackerRecordCoreData.date), date as NSDate)
    let recordFetch = try context.fetch(request)
    let record = try recordFetch.map { try createRecord(from: $0) }
    completedTrackers = Set(record)
    delegate?.didUpdateRecord(records: completedTrackers)
  }
  
  func add(_ record: TrackerRecord) throws {
    let trackerData = try trackerStore.takeTracker(for: record.trackerId)
    let recordData = TrackerRecordCoreData(context: context)
    recordData.recordId = record.id.uuidString
    recordData.date = record.date
    recordData.tracker = trackerData
    try context.save()
    completedTrackers.insert(record)
    delegate?.didUpdateRecord(records: completedTrackers)
  }
  
  func delete(_ record: TrackerRecord) throws {
    let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    request.predicate = NSPredicate(
      format: "%K == %@",
      #keyPath(TrackerRecordCoreData.recordId), record.id.uuidString)
    let records = try context.fetch(request)
    guard let wasteRecord = records.first else { return }
    context.delete(wasteRecord)
    try context.save()
    completedTrackers.remove(record)
    delegate?.didUpdateRecord(records: completedTrackers)
  }
  
  private func createRecord(from data: TrackerRecordCoreData) throws -> TrackerRecord {
    guard let stringID = data.recordId,
          let id = UUID(uuidString: stringID),
          let date = data.date,
          let trackerData = data.tracker,
          let tracker = try? trackerStore.createTracker(from: trackerData)
    else { throw TrackerError.decodeError }
    return TrackerRecord(id: id, date: date, trackerId: tracker.id)
  }
}
