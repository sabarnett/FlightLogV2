//
// File: PilotListViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class PilotsListViewModel: ObservableObject {
    
    @Published var pilotList: [Pilot] = []
    @Published var selectedPilotID: NSManagedObjectID?
    @Published var listTitle: String = "Pilots"
    @Published var listIcon: String = "person.fill"
    
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
    
    var pilotsCount: Int { pilotList.count }
    var hasPilots: Bool { pilotsCount != 0 }
    
    var searchFor: String = "" {
        didSet {
            loadPilots(includeDeleted: includeDeleted)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pilotUpdated),
                                               name: Notification.Name.pilotUpdated,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.pilotUpdated,
                                                  object: nil)
    }
    
    /// Handles the pilot updated notification. This will have been sent when the pilot was edited from
    /// the details view. It gives us the opportunity to update the list to match the new data.
    ///
    /// - Parameter data: The notification data. In this case, we will have been sent the
    /// NSManagedObjectId of the pilot that was updated.
    ///
    @objc func pilotUpdated(_ data: NSNotification?) {
        
        guard let data = data,
              let id = data.object as? NSManagedObjectID else {
            return
        }
        
        guard let pilotIndex = pilotList.firstIndex(where: { $0.objectID == id }) else {
            // It's a new pilot, requery the data
            selectedPilotID = nil
            loadPilots(includeDeleted: includeDeleted)
            selectedPilotID = id
            return
        }
        
        StorageProvider.shared.context.refresh(pilotList[pilotIndex], mergeChanges: true)
        selectedPilotID = pilotList[pilotIndex].objectID
    }
    
    func loadPilots(includeDeleted: Bool = false) {
        self.includeDeleted = includeDeleted
        
        let searchOptions = PilotSearchOptions()
        searchOptions.includeDeleted = includeDeleted
        searchOptions.textSearch = self.searchFor
        
        pilotList = Pilot.all(withOptions: searchOptions)
        
        // Is the currently selected item still in the list?
        guard let selectedPilotID,
              pilotList.contains(where: { $0.objectID == selectedPilotID}) else {
            self.selectedPilotID = nil
            return
        }
    }
    
    var selectedPilot: Pilot? {
        guard let selectedPilotID = self.selectedPilotID else { return nil }
        return pilotList.first(where: { $0.objectID == selectedPilotID })
    }
}
