//
// File: Flight+Extensions.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class FlightSearchOptions: SearchOptionsBase {
    // Additional options here please.
    var ageFilter: FlightAgeSelection?
}

extension Flight {
    var viewTitle: String { self.title ?? "" }
    var viewActivity: String { self.activity ?? "" }
    var viewLocation: String { self.location ?? "" }
    var viewWeatherConditions: String { self.weatherConditions ?? "" }
    var viewSiteConditions: String { self.siteConditions ?? "" }
    var viewPreflightChecksPerformed: Bool { self.preflightChecks }
    var viewPreflightIssuesResolved: Bool { self.preflightIssuesResolved }
    // TODO: var viewPreflightIssues: [FlightIssue] { self.preflightIssues ?? [] }
    var viewTakeOff: Date? { self.takeoff}
    var viewLanding: Date? { self.landing }
    // TODO: var viewIncidents: [FlightIssue] { self.flightIssues ?? [] }
    var viewNotes: String { self.notes ?? "" }
    
    var viewPilot: Pilot { self.pilot ?? Pilot.dummyData }
    var viewAircraft: Aircraft { self.aircraft ?? Aircraft.dummyData }
    
    var flightDeleted: Bool { self.deletedDate != nil }
    
    var viewTakeoffDate: String {
        guard let takeoff = self.takeoff else { return "Not known" }
        return takeoff.appDateTime
    }
    
    var viewLandingDate: String {
        guard let landing = self.landing else { return "not known" }
        return landing.appDateTime
    }
    
    func hasSearch(string searchFor: String) -> Bool {
        if self.viewTitle.range(of: searchFor, options: .caseInsensitive) != nil { return true }
        if self.viewActivity.range(of: searchFor, options: .caseInsensitive) != nil { return true }
        if self.viewLocation.range(of: searchFor, options: .caseInsensitive) != nil { return true }
        if self.viewNotes.range(of: searchFor, options: .caseInsensitive) != nil { return true }
        return false
    }
}

extension Flight: BaseModel {
    
    // MARK: - Public interface - static methods
    
    static func all() -> [Flight] { return fetchFlights(withOptions: FlightSearchOptions()) }
    static func all(withOptions: FlightSearchOptions) -> [Flight] { return fetchFlights(withOptions: withOptions) }

    static func count() -> Int {
        let fetchRequest: NSFetchRequest<Flight> = Flight.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        fetchRequest.resultType = .countResultType
        
        do {
            return try StorageProvider.shared.context.count(for: fetchRequest)
        } catch {
            return 0
        }
    }
    
    // MARK: - Public helper methods
    
    
    // MARK: - Private Helper functions
    fileprivate static func fetchFlights(withOptions options: FlightSearchOptions) -> [Flight] {
        
        let fetchRequest: NSFetchRequest<Flight> = Flight.fetchRequest()
        var predicates: [NSPredicate] = []
        
        // Potential predicate : Filter by deleted date
        if !options.includeDeleted {
            predicates.append(NSPredicate(format: "deletedDate = nil"))
        }
        
        // Potential predicate 2 : Search for specific text in the pilot and aitcraft
        if let searchFor = options.textSearch, searchFor.count > 0 {
            // We have search text!
            let searchFirstName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.firstName), searchFor)
            let searchLastName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.lastName), searchFor)
            let searchAddress = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.address), searchFor)
            let searchMobile = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.mobilePhone), searchFor)
            let searchAircraftName = NSPredicate(format: "%K CONTAINS[cd] &@", #keyPath(Aircraft.name), searchFor)
            let searchAircraftModel = NSPredicate(format: "%K CONTAINS[cd] &@", #keyPath(Aircraft.model), searchFor)
            let searchAircraftMaker = NSPredicate(format: "%K CONTAINS[cd] &@", #keyPath(Aircraft.manufacturer), searchFor)

            let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                searchFirstName,
                searchLastName,
                searchAddress,
                searchMobile,
                searchAircraftName,
                searchAircraftModel,
                searchAircraftMaker
            ])

            predicates.append(searchPredicate)
        }
        
        // Potential predicate : Limit the results based on the takeoff date
        if let ageFilter = options.ageFilter {
            var fromDate: Date?
            let baseDate = calculateBaseDate()
            let calendar = Calendar.current
            
            // We need to add to the predicate for the age of the records (based on takeOff date).
            switch ageFilter {
            case .lastWeek:
                fromDate = calendar.date(byAdding: .day, value: -7, to: baseDate)
            case .lastMonth:
                fromDate = calendar.date(byAdding: .month, value: -1, to: baseDate)
            case .threeMonths:
                fromDate = calendar.date(byAdding: .month, value: -3, to: baseDate)
            case .sixMonths:
                fromDate = calendar.date(byAdding: .month, value: -6, to: baseDate)
            case .year:
                fromDate = calendar.date(byAdding: .year, value: -1, to: baseDate)
            case .allFlights:
                // No filter needed
                fromDate = nil
            }
            
            if let fromDate {
                // Create predicate
                let datePredicate = NSPredicate(format: "%K > %@",
                                                #keyPath(Flight.takeoff),
                                                fromDate as CVarArg)
                predicates.append(datePredicate)
            }
        }
        
        // Only create the fetch request predicate if we created some. These will all be ANDed together.
        if !predicates.isEmpty {
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = predicate
        }
        
        // Set the sort order based on the pilot name
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Flight.takeoff), ascending: true),
            NSSortDescriptor(key: #keyPath(Flight.pilot.lastName), ascending: true),
            NSSortDescriptor(key: #keyPath(Flight.pilot.firstName), ascending: true)
        ]

        do {
            return try StorageProvider.shared.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    // MARK: - Dummy data for preview usage
    static var dummyData: Flight {
        let flight = Flight.create() as Flight
        
        let preflightIssue1 = FlightIssue()
        preflightIssue1.title = "Loose linkage"
        preflightIssue1.notes = "Linkage to nose gear was loose and required tightening"
        let preflightIssue2 = FlightIssue()
        preflightIssue2.title = "Battery Low"
        preflightIssue2.notes = "Battery was low, so was swapped out for a fresh one."

        let incident = FlightIssue()
        incident.title = "Nose gear collapse on landing"
        incident.notes = "The nmose gear collapsed on landing. This was due to hitting a small hole on the landing strip. Not an issue as much as an unfortunate accident."
        
        flight.title = "Dummy Flight"
        flight.pilot = Pilot.dummyData
        flight.aircraft = Aircraft.dummyData
        flight.activity = "Brief description of what we want to achieve. Can be as simple as 'pleasure trip' or something more complex."
        flight.location = "Dorking Air Field"
        flight.weatherConditions = "Overcast, light drizzle"
        flight.siteConditions = "Clise cropped grass, slightle wet"
        flight.preflightChecks = true
        flight.preflightIssuesResolved = true
        flight.preflightIssues = [
            preflightIssue1,
            preflightIssue2
        ]
        flight.takeoff = Date() - TimeInterval(6000)
        flight.landing = Date()
        flight.flightIssues = [
            incident
        ]
        flight.notes = "Flight notes"
        
        return flight
    }
    
    /// Calculate todays date and set the time to 00:00:00
    ///
    /// - Returns: Todays date with the time set to 00:00:00
    fileprivate static func calculateBaseDate() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.now)

        components.timeZone = TimeZone(abbreviation: "UTC")
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components) ?? Date.now
    }
}
