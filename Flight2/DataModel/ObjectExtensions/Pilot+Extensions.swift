//
// File: Pilot+Extensions.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 08/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import UtilityViews
import UtilityClasses

class PilotSearchOptions: SearchOptionsBase {
    // Additional options here please.
}

extension Pilot {
    
    var viewFirstName: String { self.firstName ?? "" }
    var viewLastName: String { self.lastName ?? "" }
    var viewCAARegistration: String { self.caaRegistration ?? "" }
    var viewMobilePhone: String { self.mobilePhone ?? "" }
    var viewAlternatePhone: String { self.homePhone ?? "" }
    var viewEmailAddress: String { self.email ?? "" }
    var viewProfileImage: UIImage { self.profileImage?.image ?? UIImage(named: "person-placeholder")!}
    var viewDisplayName: String { self.displayName }
    var viewAddress: String { self.address ?? "" }
    var viewPostCode: String { self.postCode ?? "" }
    
    var pilotDeleted: Bool { self.deletedDate != nil }
}

extension Pilot: BaseModel {
    
    // MARK: - Public interface - static methods
    
    static func all() -> [Pilot] { return fetchPilots(withOptions: PilotSearchOptions()) }
    static func all(withOptions: PilotSearchOptions) -> [Pilot] { return fetchPilots(withOptions: withOptions) }
    
    static func count() -> Int {
        let fetchRequest: NSFetchRequest<Pilot> = Pilot.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        fetchRequest.resultType = .countResultType
        
        do {
            return try StorageProvider.shared.context.count(for: fetchRequest)
        } catch {
            return 0
        }
    }
    
    static func pickerData() -> [PickerOption] {
        let fetchRequest: NSFetchRequest<Pilot> = Pilot.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Pilot.lastName), ascending: true),
            NSSortDescriptor(key: #keyPath(Pilot.firstName), ascending: true)
        ]
        
        do {
            return try StorageProvider.shared.context.fetch(fetchRequest).map { pilot in
                PickerOptionWithKey(image: pilot.profileImage?.image,
                                    title: pilot.displayName,
                                    subTitle: pilot.caaRegistration ?? "",
                                    managedObjectID: pilot.objectID)
            }
        } catch {
            return []
        }
    }
    
    var displayName: String {
        "\(lastName ?? ""), \(firstName ?? "")"
    }
    
    // MARK: - Public helper methods
    
    /// Deletes the profile picture associated with the current pilot instanmce. The profileImage will be
    /// reset in the pilot object and the picture wioll be deleted from the SavedImages table.
    func clearProfileImage() {
        guard let profilePicture = self.profileImage else { return }
        
        // Delete the existing image
        StorageProvider.shared.context.delete(profilePicture)
        profileImage = nil
    }
    
    /// Adds or updates thge profileImage for this pilot. If there was already a profile image, the picture
    /// will be replaced. If there is no existing profile image, a new SavedImage will be created and attached
    /// to the pilot.
    ///
    /// The image itself will not be saved in this code. It is assumed that the context will be saved later.
    ///
    /// - Parameter image: The UIImage to be associated with the pilot
    func setProfileImage(_ image: UIImage) {
        if let profilePicture = profileImage {
            // Existing image, so update it.
            profilePicture.image = image
            return
        }
        
        let newImage = SavedImage(context: StorageProvider.shared.context)
        newImage.image = image
        profileImage = newImage
    }
    
    // MARK: - Private Helper functions
    fileprivate static func fetchPilots(withOptions options: PilotSearchOptions) -> [Pilot] {
        
        let fetchRequest: NSFetchRequest<Pilot> = Pilot.fetchRequest()
        
        if !options.includeDeleted {
            fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Pilot.lastName), ascending: true),
            NSSortDescriptor(key: #keyPath(Pilot.firstName), ascending: true)
        ]
        
        if let searchFor = options.textSearch, searchFor.count > 0 {
            // We have search text!
            let searchFirstName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.firstName), searchFor)
            let searchLastName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.lastName), searchFor)
            let searchAddress = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.address), searchFor)
            let searchMobile = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.mobilePhone), searchFor)
            
            let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                searchFirstName,
                searchLastName,
                searchAddress,
                searchMobile])
            
            fetchRequest.predicate = searchPredicate
        }
        
        do {
            return try StorageProvider.shared.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    // MARK: - Dummy data for preview usage
    static var dummyData: Pilot {
        let pilot = Pilot.create() as Pilot
        
        pilot.firstName = "Dummy"
        pilot.lastName = "Pilot"
        pilot.caaRegistration = "AAA-BBBBBBBB-CCCC"
        pilot.mobilePhone = "07910 111 222"
        pilot.homePhone = "0121 222 3333"
        pilot.email = "dummy@example.com"
        pilot.address = "Line 1\nLine 2\nLine 3"
        pilot.postCode = "V12 7RR"
        pilot.profileImage = nil
        
        return pilot
    }
}

extension Pilot {
    
    static func statistics(for pilot: Pilot) -> StatisticsSummary {
        
        let statistics = Statistics()
        return statistics.getStatistics(forPilot: pilot)
    }
}

class Statistics {
    
    private var fieldsToRetrieve = ["takeoff",
                                    "landing",
                                    "aircraft.name",
                                    "pilot.caaRegistration",
                                    "pilot.firstName",
                                    "pilot.lastName"]
    
    private var pilotSortKey = "aircraft.name"
    private var pilotPredicate = "pilot.caaRegistration = %@"
    
    private var aircraftSortKey = "pilot.caaRegistration"
    private var aircraftPredicate = "aircraft.name = %@"

    public func getStatistics(forPilot pilot: Pilot) -> StatisticsSummary {
        
        var displayStats: StatisticsSummary = StatisticsSummary()

        let fetchRequest = buildFetchRequest(predicateFormat: pilotPredicate,
                                             predicateValue: pilot.viewCAARegistration,
                                             sortBy: pilotSortKey)
        
        do {
            let results = try StorageProvider.shared.context.fetch(fetchRequest)
            let stats = transform(results: results)
            let aircraftStats = groupStatsByAircraft(stats)
            displayStats = summarise(stats: aircraftStats)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return displayStats
    }
    
    public func getStatistics(forAircraft aircraft: Aircraft) -> StatisticsSummary {
        
        var displayStats: StatisticsSummary = StatisticsSummary()
        
        let fetchRequest = buildFetchRequest(predicateFormat: aircraftPredicate,
                                             predicateValue: aircraft.viewName,
                                             sortBy: aircraftSortKey)
        
        do {
            let results = try StorageProvider.shared.context.fetch(fetchRequest)
            let stats = transform(results: results)
            let pilotStats = groupStatsByPilot(stats)
            displayStats = summarise(stats: pilotStats)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return displayStats
    }

    private func buildFetchRequest(predicateFormat: String,
                                   predicateValue: String,
                                   sortBy: String) -> NSFetchRequest<NSDictionary> {

        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: Flight.entity().name!)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "deletedDate = nil"),
            NSPredicate(format: predicateFormat, predicateValue)
        ])
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: sortBy, ascending: true) ]
        fetchRequest.propertiesToFetch = fieldsToRetrieve
        
        return fetchRequest
    }
    
    private func transform(results: [NSDictionary]) -> [StatisticsItem] {
        results.map(StatisticsItem.init).filter { $0.flightDuration > 0 }
    }
    
    private func groupStatsByAircraft(_ stats: [StatisticsItem]) -> [String: [StatisticsItem]] {
        Dictionary(grouping: stats, by: { item in
            item.aircraftName
        })
    }
    
    private func groupStatsByPilot(_ stats: [StatisticsItem]) -> [String: [StatisticsItem]] {
        Dictionary(grouping: stats, by: { item in
            item.pilotName
        })
    }
    
    private func summarise(stats: [String: [StatisticsItem]]) -> StatisticsSummary {
     
        var summary = StatisticsSummary()
        
        for item in stats {
            var summaryItem = StatisticsSummaryItem()
            summaryItem.title = item.key
            summaryItem.count = item.value.count
            summaryItem.duration = item.value.reduce(0) { $0 + $1.flightDuration }
            
            summary.flightCount += summaryItem.count
            summary.flightDuration += summaryItem.duration
            
            summary.detail.append(summaryItem)
        }
        
        return summary
    }

    private struct StatisticsItem {
        
        init(from decoder: NSDictionary) {
            WriteLog.debug(decoder)
            
            aircraftName = decoder.value(forKey: "aircraft.name") as! String
            caaRegstration = decoder.value(forKey: "pilot.caaRegistration") as! String
            pilotFirstName = decoder.value(forKey: "pilot.firstName") as! String
            pilotLastName = decoder.value(forKey: "pilot.lastName") as! String
            
            takeoff = decoder.value(forKey: "takeoff") as? Date
            landing = decoder.value(forKey: "landing") as? Date
        }

        var takeoff: Date?
        var landing: Date?
        var aircraftName: String
        var caaRegstration: String
        var pilotFirstName: String
        var pilotLastName: String
        
        var flightDuration: Int {
            guard let takeOffDate = takeoff, let landingDate = landing else {
                return 0
            }
            
            let duration = landingDate - takeOffDate
            return 1
        }
        
        var pilotName: String {
            "\(pilotLastName), \(pilotFirstName)"
        }
    }
}

struct StatisticsSummary {
    
    var flightCount: Int = 0
    var flightDuration: Int = 0
    
    var detail: [StatisticsSummaryItem] = []
}

struct StatisticsSummaryItem {
    var title: String = ""
    var duration: Int = 0
    var count: Int = 0
}
