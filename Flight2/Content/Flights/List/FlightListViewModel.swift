//
// File: FlightListViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 11/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import CoreData
import UtilityClasses

class FlightListViewModel: ObservableObject {
    
    var flights: [String: [Flight]] = [:]
    
    @Published var primaryList: [Flight] = []
    @Published var primarySelection: NSManagedObjectID? {
        didSet {
            secondaryList = buildSecondaryList(forId: primarySelection)
        }
    }
    @Published var primaryListId: UUID = UUID()
    
    @Published var secondaryList: [Flight] = []
    @Published var secondarySelection: NSManagedObjectID?
    
    @Published var selectedFlightID: NSManagedObjectID = NSManagedObjectID()
    @Published var showActiveFlights: Bool = false
    
    @Published var listTitle: String = ""
    @Published var listIcon: String = ""

    var selectedFlight: Flight {
            guard let selectedFlightId = secondarySelection else {
                return Flight.dummyData
            }
            
            guard let selected = flightList.first(where: { $0.objectID == selectedFlightId}) else {
                return Flight.dummyData
            }
            
            return selected
    }
    
    @AppStorage("showDeletedFlights") var showDeleted: Bool = false
    @AppStorage("GroupedBy") var groupBy: GroupFlightsBy = .pilot
    @AppStorage("FlightPeriod") var ageFilter: FlightAgeSelection = .lastMonth
    
    var groupedByOpposite: GroupFlightsBy {        
        groupBy == .pilot ? .aircraft : .pilot
    }
    
    // A change in these variables will require us to re-build the dictionary only. The fetched
    // data will have everytghing we need.
    var searchFor: String = "" { didSet { buildFlightDictionary() } }
    var selectGroup: String = "All" { didSet { buildFlightDictionary() }}
    
    // This is the data that gets used to build the display.
    private var flightList: [Flight] = []
    var flightsCount: Int { flights.count }
    var hasFlights: Bool { flightsCount != 0 }
    
    // Helper storage
    private var previousAgeFilter: FlightAgeSelection = .lastMonth
    
    private var hasPilotsAndAircraft: Bool?
    var canAdd: Bool {
        if let hasPilotsAndAircraft { return hasPilotsAndAircraft }
        // Not yet set, so go calculate it.
        hasPilotsAndAircraft = Pilot.count() > 0 && Aircraft.count() > 0
        return hasPilotsAndAircraft!
    }
    
    // MARK: - Initialisation and cleanup
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(flightUpdated),
                                               name: Notification.Name.flightUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.flightUpdated,
                                                  object: nil)
    }
    
    /// Handles the flight updated notification. This will have been sent when a flight was edited from
    /// the details view. It gives us the opportunity to update the list to match the new data.
    ///
    /// - Parameter data: The notification data. In this case, we will have been sent the
    /// NSManagedObjectId of the flight that was updated.
    ///
    @objc func flightUpdated(_ data: NSNotification?) {
        
        guard let data = data,
              let id = data.object as? NSManagedObjectID else {
            return
        }
        
        guard let flightIndex = flightList.firstIndex(where: { $0.objectID == id }) else {
            // It's a new flight, requery the data
            refreshData(forceLoad: true)
            selectedFlightID = id
            return
        }
        
        // Update the flight in the item
        StorageProvider.shared.context.refresh(flightList[flightIndex], mergeChanges: true)
        selectedFlightID = flightList[flightIndex].objectID
    }
    
    // MARK: - Public interface
    
    /// Retrieves a list of the names of the groups in the dictionary.  This is sourced from the original array
    /// of flights as there may be filters applied to the flight dictionary. This routine will always return the
    /// full list of keys regardless of any filtering.
    ///
    /// - Returns: An array of the dictionary keys
    ///
    func groupNames(for groupBy: GroupFlightsBy) -> [String] {
        return Array(Set(flightList.map {
            switch groupBy {
            case .pilot:
                return $0.pilot?.displayName ?? ""
            case .aircraft:
                return $0.aircraft?.name ?? ""
            }
        }))
    }
    
    /// Given a group name (ket in the flights dictionary), we retrieve the image associated with the key. This
    /// might be a pilot image or an aircraft image, depending on hiw the data was grouped.
    ///
    /// - Parameter group: The group name (pilot ir aircraft name)
    /// - Returns: The image associated with the pilor or aircraft. Returns nil if there is no image
    ///
    func headerImage(for group: String) -> UIImage? {
        // Depending on grouping, find the first image for the pilot or the aircraft.
        switch groupBy {
        case .pilot:
            return flightList.first(where: { flight in
                flight.viewPilot.displayName == group
            })?.viewPilot.profileImage?.image
            
        case .aircraft:
            return flightList.first(where: { flight in
                flight.viewAircraft.name == group
            })?.viewAircraft.aircraftImage?.image
        }
    }
    
    /// Refresh the data dictionary used to build the view. By default, we just reapply the filters and rebuild the dictionary
    /// of flights. We will only reload the data from the database if the user forces us to.
    ///
    /// - Parameter forceLoad: When true, indicates that we need tomake a round trip to the database for the data.
    ///
    func refreshData(forceLoad: Bool = false) {
        listTitle = groupBy == .pilot ? "Pilots" : "Aircraft"
        listIcon = groupBy == .pilot ? "person.fill" : "airplane"

        if forceLoad {
            loadFlights()
        } else {
            buildFlightDictionary()
        }
    }
    
    // MARK: - Private helpers
    
    private func loadFlights() {
        let searchOptions = FlightSearchOptions()
        searchOptions.includeDeleted = showDeleted
        searchOptions.textSearch = nil              // SearchFor filtering is done in the view model to reduce database calls.
        searchOptions.ageFilter = ageFilter
        
        flightList = Flight.all(withOptions: searchOptions)
        buildFlightDictionary()
    }
    
    private func buildFlightDictionary() {
        
        WriteLog.info("Create dictionary using limit: \(selectGroup) "
                      + "for group \(groupBy) with "
                      + "age limit \(ageFilter.description)")
        
        // Do we have an age filter. If we do, we must force a database round trip as we may not have
        // all the records we need.
        if ageFilter != previousAgeFilter {
            previousAgeFilter = ageFilter
            
            WriteLog.warning("The age filter has changed from \(previousAgeFilter) to \(ageFilter), reload data")
            loadFlights()
            return
        }
        
        var flightGroup = createFlightDictionary()
        flightGroup = filterByGroup(flightGroup)
        flightGroup = applySearchFilter(flightGroup)
        flightGroup = applyActiveFilter(flightGroup)
        
        // We have completed the filtering, remove anything that has no flights left
        for (key, flights) in flightGroup where flights.count == 0 {
            flightGroup[key] = nil
        }
        
        WriteLog.info("Group list created with \(flightGroup.count) items in it.")
        flights = flightGroup
        
        let primaryList = buildPrimaryList(flightGroup)
        
        updatePublishedList(primaryList)
        
    }
    
    func buildSecondaryList(forId: NSManagedObjectID?) -> [Flight] {
        // Key is nil, return an empty list
        guard let id = forId else { return [] }
        
        WriteLog.info("Locate the flight")
        // Locate the corresponding flight, or return an empty list
        guard let flight = flightList.first(where: { flight in flight.objectID == id}) else {
            return []
        }
        
        var dictionaryKey = ""
        switch groupBy {
        case .pilot:
            dictionaryKey = flight.pilot?.displayName ?? ""
        case .aircraft:
            dictionaryKey = flight.aircraft?.name ?? ""
        }
        
        WriteLog.info("Find flights in dictionary for key \(dictionaryKey)")
        // Get the list of matching flights
        guard var flights = flights[dictionaryKey]  else { return [] }
        flights.sort(by: {
            guard let takeoff = $0.takeoff else { return true }
            guard let takeoff2 = $1.takeoff else { return false }
            return takeoff < takeoff2
        })
        
        WriteLog.info("\(flights.count) flights found")
        return flights
    }
    
    // MARK: - Flight analysis helper functions
    
    /// Build the dictionary. The key is the name of the pilot or the aircraft, depending on what grouping
    /// the user selecfted. The values is an array of matching flights.
    private func createFlightDictionary() -> [String: [Flight]] {
        WriteLog.info("Grouping flights by \(groupBy)")
        return Dictionary(grouping: flightList, by: { flight in
            switch groupBy {
            case .pilot:
                return flight.pilot?.displayName ?? ""
            case .aircraft:
                return flight.aircraft?.name ?? ""
            }
        })
    }
    
    /// If a specific pilot or aircraft has been selected, filter the dictionary to only include the
    /// specific pilot or aircraft.
    private func filterByGroup(_ flightGroup: [String: [Flight]]) -> [String: [Flight]] {
        WriteLog.info("Limit to be applied: \(selectGroup)")
        if selectGroup == "All" { return flightGroup }
        
        let groupItem = flightGroup.first(where: { key, value in
            key == selectGroup
        })
        if let groupItem {
            var filteredFlightGroup: [String: [Flight]] = [:]
            filteredFlightGroup[groupItem.key] = groupItem.value
            return filteredFlightGroup
        }
        
        return flightGroup
    }
    
    /// If we have specific text to search for, search that now and remove any flights that do not match
    /// the search text.
    private func applySearchFilter(_ flightGroup: [String: [Flight]]) -> [String: [Flight]] {
        if searchFor.isEmpty { return flightGroup }
        
        WriteLog.info("Filter results, search for '\(searchFor)'")
        
        var filteredFlightGroup: [String: [Flight]] = [:]
        for (key, flights) in flightGroup {
            var matchingFlights: [Flight] = []
            for flight in flights {
                if flight.hasSearch(string: searchFor) {
                    matchingFlights.append(flight)
                }
            }
            
            if matchingFlights.count > 0 {
                filteredFlightGroup[key] = matchingFlights
            }
        }

        return filteredFlightGroup
    }
    
    /// All flights or active flights only? Active flights will not have a landing date/time
    private func applyActiveFilter(_ flightGroup: [String: [Flight]]) -> [String: [Flight]] {
        if !showActiveFlights { return flightGroup }
        
        WriteLog.info("Only show active flights. Filter anything out that has a landing date")
        
        var filteredFlightGroup: [String: [Flight]] = [:]
        for (key, flights) in flightGroup {
            var matchingFlights: [Flight] = []
            for flight in flights where flight.landing == nil {
                matchingFlights.append(flight)
            }
            
            if matchingFlights.count > 0 {
                filteredFlightGroup[key] = matchingFlights
            }
        }

        return filteredFlightGroup
    }
    
    /// What we have now is a dictionary, keyed off the pilot or aircraft. For each entry, the key is
    /// the name and the value is the list of applicable flights. That's great for the second column
    /// list, but not helpful for the first column. We now need to create a list of flights that
    /// matches the keys of the dictionary, so we have a list of 'primary' flight instances to
    /// build the first list with.
    private func buildPrimaryList(_ flightGroup: [String: [Flight]]) -> [Flight] {
        
        var primaryList: [Flight] = []
        for (key, _) in flightGroup {
            // The key is the displayname of the pilot or the description of an aircraft.
            switch groupBy {
            case .pilot:
                if let flight = flightList.first(where: { flight in
                    flight.viewPilot.viewDisplayName == key
                }) {
                    primaryList.append(flight)
                }
                
            case .aircraft:
                if let flight = flightList.first(where: { flight in
                    flight.viewAircraft.name == key
                }) {
                    primaryList.append(flight)
                }
            }
        }
        
        primaryList.sort(by: {
            switch groupBy {
            case .pilot:
                return $0.viewPilot.viewDisplayName < $1.viewPilot.viewDisplayName
            case .aircraft:
                return $0.viewAircraft.viewName < $1.viewAircraft.viewName
            }
        })
        
        return primaryList
    }
    
    private func updatePublishedList(_ primaryList: [Flight]) {
        WriteLog.info("Updating the primary list")
        self.primaryList = primaryList
        self.primarySelection = nil
        
        WriteLog.info("Clearing secondary selection")
        secondarySelection = nil

        WriteLog.info("Force re-generate the list")
        self.primaryListId = UUID()
    }
}
