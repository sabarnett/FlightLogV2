//
// File: FlightListViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 11/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import CoreData

class FlightListViewModel: ObservableObject {
    
    @Published var flights: Dictionary<String, [Flight]> = [:]
    @Published var selectedFlightID: NSManagedObjectID = NSManagedObjectID()
    @Published var showActiveFlights: Bool = false
    
    @AppStorage("showDeletedFlights") var showDeleted: Bool = false
    @AppStorage("GroupedBy") var groupBy: GroupFlightsBy = .pilot
    @AppStorage("FlightPeriod") var ageFilter: FlightAgeSelection = .lastMonth
    
    // A change in these variables will require us to re-build the dictionary only. The fetched
    // data will have everytghing we need.
    var searchFor: String = "" { didSet { buildFlightDictionary() } }
    var selectGroup: String = "All"  { didSet { buildFlightDictionary() }}
    
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
        
        guard var flightIndex = flightList.firstIndex(where: { $0.objectID == id }) else {
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
    
    /// Retrieves a list of the names of the groups in the dictionary.  This is sourced from the original array of flights as there
    /// may be filters applied to the flight dictionary. This routine will always return the full list of keys regardless of any filtering.
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
    
    /// Given a group name (ket in the flights dictionary), we retrieve the image associated with the key. This mighjt be a pilot image
    /// or an aircraft image, depending on hiw the data was grouped.
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
        
        WriteLog.info("Create dictionary using limit: \(selectGroup) for group \(groupBy) with age limit \(ageFilter.description)")
        
        // STEP 1: Do we have an age filter. If we do, we must force a database round trip as we may not have
        //         all the records we need.
        if ageFilter != previousAgeFilter {
            previousAgeFilter = ageFilter
            
            WriteLog.warning("The age filter has changed from \(previousAgeFilter) to \(ageFilter), reload data")
            loadFlights()
            return
        }
        
        // STEP 2: Build the dictionary. The key is the name of the pilot or the aircraft, depending on what grouping
        //         the user selecfted. The values is an array of matching flights.
        var flightGroup = Dictionary(grouping: flightList, by: { flight in
            switch groupBy {
            case .pilot:
                return flight.pilot?.displayName ?? ""
            case .aircraft:
                return flight.aircraft?.name ?? ""
            }
        })
        
        // STEP 3: If a specific pilot or aircraft has been deleted, filter the dictionary to only include the
        //         specific pilot or aircraft.
        if selectGroup != "All" {
            WriteLog.info("Limit to be applied: \(selectGroup)")
            let groupItem = flightGroup.first(where: { key, value in
                key == selectGroup
            })
            if let groupItem {
                flightGroup = [:]
                flightGroup[groupItem.key] = groupItem.value
            }
        }
        
        // STEP 4: If we have specific text to search for, search that now and remove any flights that do not match
        //         the search text.
        if !searchFor.isEmpty {
            WriteLog.info("Filter results, search for '\(searchFor)'")
            
            for (key, flights) in flightGroup {
                for flight in flights {
                    if !flight.hasSearch(string: searchFor) {
                        flightGroup[key]?.removeAll(where: {$0.id == flight.id })
                    }
                }
            }
        }
        
        // STEP 5: All flights or active flights only?
        if showActiveFlights {
            WriteLog.info("Only show active flights. Filter anything out that has a landing date")
            for (key, flights) in flightGroup {
                for flight in flights {
                    if flight.landing != nil {
                        flightGroup[key]?.removeAll(where: {$0.id == flight.id })
                    }
                }
            }
        }
        
        // STEP 6: Remove anything that has no flights left
        for (key, flights) in flightGroup {
            if flights.count == 0 {
                flightGroup[key] = nil
            }
        }
        
        WriteLog.info("Group list created with \(flightGroup.count) items in it.")
        flights = flightGroup
    }
    
}
