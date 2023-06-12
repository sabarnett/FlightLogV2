//
// File: Statistics.swift
// Package: Flight2
// Created by: Steven Barnett on 12/06/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import UtilityClasses

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
        
        var flightDuration: Double {
            guard let takeOffDate = takeoff, let landingDate = landing else {
                return 0
            }
            
            // Duration is in seconds. We want duration in minutes.
            let duration = landingDate - takeOffDate
            return duration / 60
        }
        
        var pilotName: String {
            "\(pilotLastName), \(pilotFirstName)"
        }
    }
}

struct StatisticsSummary {
    
    var flightCount: Int = 0
    var flightDuration: Double = 0
    
    var detail: [StatisticsSummaryItem] = []
    
    var formattedFlightDuration: String {
        String(format: "%.0f", flightDuration)
    }
}

struct StatisticsSummaryItem: Identifiable {
    let id: UUID = UUID()
    
    var title: String = ""
    var duration: Double = 0
    var count: Int = 0

    var formattedFlightDuration: String {
        String(format: "%.0f", duration)
    }
}
