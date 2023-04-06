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
    
    @Published var pilotList: [pilotListModel] = []
    @Published var selectedPilot: NSManagedObjectID?
    
    // This is abit of a fudge. If we have updated a pilot in the detail view, we need to
    // get the listview to update. It won't do that because it reuses the old structs for the
    // data, so the list uses old data. To fix this, we give the list an id and we change that
    // id when we are told that the pilot has been changed. The change of list id will force it
    // to refresh the data.
    //
    // Note; we only need this for iPad in master/detail view. On the phone, the list will update
    // correctly when the list is re-displayed, just by updating the listId.
    @Published var listRefresh: UUID = UUID()
    
    var pilotToDelete: pilotListModel?
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
        
        guard var pilotModel = pilotList.first(where: { $0.id == id }) else {
            // It's a new pilot, requery the data
            loadPilots(includeDeleted: includeDeleted)
            selectedPilot = id
            return
        }
        
        // Update the pilot in the item
        if let updatedPilot = Pilot.byId(id: id) as? Pilot  {
            pilotModel.pilot = updatedPilot
            pilotModel.listId = UUID()

            // Force the list to refresh
            self.listRefresh = UUID()
            
            selectedPilot = pilotModel.id
        }
    }
    
    func loadPilots(includeDeleted: Bool = false) {
        self.includeDeleted = includeDeleted
        
        let searchOptions = PilotSearchOptions()
        searchOptions.includeDeleted = includeDeleted
        searchOptions.textSearch = self.searchFor
        
        pilotList = Pilot.all(withOptions: searchOptions).map { pilotListModel(pilot: $0) }
    }
    
    func getSelectedPilot() -> pilotListModel? {
        pilotList.first(where: { $0.id == selectedPilot })
    }
}

struct pilotListModel: Hashable, Identifiable {
    
    var pilot: Pilot
    var listId: UUID = UUID()
    
    var id: NSManagedObjectID {
        pilot.objectID
    }
    
    var firstName: String { pilot.firstName ?? "" }
    var lastName: String { pilot.lastName ?? "" }
    var caaRegistration: String { pilot.caaRegistration ?? "" }
    var mobilePhone: String { pilot.mobilePhone ?? "" }
    var alternatePhone: String { pilot.homePhone ?? "" }
    var emailAddress: String { pilot.email ?? "" }
    var profileImage: UIImage { pilot.profileImage?.image ?? UIImage(named: "person-placeholder")!}
    var displayName: String { pilot.displayName }
    
    var isDeleted: Bool { pilot.deletedDate != nil }
    
    init(pilot: Pilot, listId: UUID = UUID()) {
        self.pilot = pilot
        self.listId = listId
    }
}
