//
// File: AircraftDetailViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 10/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class AircraftDetailViewModel: ObservableObject {
    
    @Published var aircraft: Aircraft
    @Published var aircraftId: NSManagedObjectID?
    @Published var statistics: StatisticsSummary
    
    // MARK: - Initialisation and cleanup

    init(aircraft: Aircraft) {
        self.aircraftId = aircraft.objectID
        self.aircraft = aircraft
        self.statistics = Aircraft.statistics(for: aircraft)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(aircraftUpdated),
                                               name: Notification.Name.aircraftUpdated,
                                               object: nil)    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.aircraftUpdated,
                                                  object: nil)
    }
    
    /// Handles the aircraft updated notification. This will have been sent when an aircraft was edited from
    /// the details view. It gives us the opportunity to update the detail view to match the new data.
    ///
    /// - Parameter data: The notification data. In this case, we will have been sent the
    /// NSManagedObjectId of the flight that was updated.
    ///
    @objc func aircraftUpdated(_ data: NSNotification?) {
        
        guard let data = data,
              let id = data.object as? NSManagedObjectID else {
            return
        }
        
        if self.aircraftId == id {
            // We need to refresh the data.
            self.aircraftId = id
            self.aircraft = Aircraft.byId(id: id) as! Aircraft
            self.statistics = Aircraft.statistics(for: aircraft)
        }
    }
    
    func reloadData() {
        StorageProvider.shared.context.refresh(aircraft, mergeChanges: true)
    }
    
    func deleteAircraft() {
        setDeletedState(forAircraft: self.aircraft, isDeleted: true)
    }
    
    func undeleteAircraft() {
        setDeletedState(forAircraft: self.aircraft, isDeleted: false)
    }
    
    private func setDeletedState(forAircraft aircraft: Aircraft, isDeleted: Bool) {
        aircraft.deletedDate = isDeleted ? Date() : nil
        aircraft.save()
    }
}
