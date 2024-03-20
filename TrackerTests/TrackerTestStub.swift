//
//  TrackerTestStub.swift
//  TrackerTests
//
//  Created by Леонид Турко on 19.03.2024.
//

@testable import Tracker
import Foundation

final class TrackerTestStub: TrackerStoreProtocol {
    var trackersCount: Int = 2
    var numberOfSections: Int = 1
    var delegate: TrackerStoreDelegate?
    private static let category = TrackerCategory(name: "Веселье")
    private static let trackersBundle: [Tracker] = [
            Tracker(
                name: "Жесткий кодинг",
                color: .trackerColors[0],
                emoji: "🏓",
                sked: [.monday, .tuesday, .wednesday, .thursday, .friday],
                daysCount: 150,
                attach: false,
                category: category
            )
        ]
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return 1
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackers = TrackerTestStub.trackersBundle[indexPath.row]
        return trackers
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategory) throws {
    }
    
    func headerInSection(_ section: Int) -> String? {
        return TrackerTestStub.category.name
    }
    
    func currentlyTrackers(date: Date, searchString: String, filter: Filter) throws {
    }
    
    func takeTrackersForFilter(date: Date) throws {
    }
    
    func deleteTracker(tracker: Tracker) throws {
    }
    
    func editTracker(tracker: Tracker, data: Tracker.Data) throws {
    }
    
    func turnAttach(tracker: Tracker) throws {
    }
    
}
