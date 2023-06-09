//
// File: AircraftListViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 10/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class AircraftListViewModel: ObservableObject {
    
    @Published var aircraftList: [Aircraft] = []
    @Published var selectedAircraftID: NSManagedObjectID?
    @Published var listTitle: String = "Aircraft"
    @Published var listIcon: String = "airplane"
    
    // This is abit of a fudge. If we have updated a pilot in the detail view, we need to
    // get the listview to update. It won't do that because it reuses the old structs for the
    // data, so the list uses old data. To fix this, we give the list an id and we change that
    // id when we are told that the pilot has been changed. The change of list id will force it
    // to refresh the data.
    //
    // Note; we only need this for iPad in master/detail view. On the phone, the list will update
    // correctly when the list is re-displayed, just by updating the listId.
    @Published var listRefresh: UUID = UUID()
    
    var includeDeleted: Bool = false
    
    var aircraftCount: Int { aircraftList.count }
    var hasAircraft: Bool { aircraftCount != 0 }
    
    var searchFor: String = "" {
        didSet {
            loadAircraft(includeDeleted: includeDeleted)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(aircraftUpdated),
                                               name: Notification.Name.aircraftUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.aircraftUpdated,
                                                  object: nil)
    }
    
    /// Handles the pilot updated notification. This will have been sent when the aircraft was edited from
    /// the details view. It gives us the opportunity to update the list to match the new data.
    ///
    /// - Parameter data: The notification data. In this case, we will have been sent the
    /// NSManagedObjectId of the aircraft that was updated.
    ///
    @objc func aircraftUpdated(_ data: NSNotification?) {
        
        guard let data = data,
              let id = data.object as? NSManagedObjectID else {
            return
        }
        
        guard let aircraftIndex = aircraftList.firstIndex(where: { $0.objectID == id }) else {
            // It's a new pilot, requery the data
            selectedAircraftID = nil
            loadAircraft(includeDeleted: includeDeleted)
            selectedAircraftID = id
            return
        }
        
        StorageProvider.shared.context.refresh(aircraftList[aircraftIndex], mergeChanges: true)
        selectedAircraftID = aircraftList[aircraftIndex].objectID
        listRefresh = UUID()
    }
    
    func loadAircraft(includeDeleted: Bool = false) {
        self.includeDeleted = includeDeleted
        
        let searchOptions = AircraftSearchOptions()
        searchOptions.includeDeleted = includeDeleted
        searchOptions.textSearch = self.searchFor
        
        aircraftList = Aircraft.all(withOptions: searchOptions)
        
        // Is the currently selected item still in the list?
        guard let selectedAircraftID,
              aircraftList.contains(where: { $0.objectID == selectedAircraftID}) else {
            self.selectedAircraftID = nil
            return
        }
    }
    
    var selectedAircraft: Aircraft? {
        guard let selectedAircraftID = self.selectedAircraftID else { return nil }
        return aircraftList.first(where: { $0.objectID == selectedAircraftID })
    }
}
