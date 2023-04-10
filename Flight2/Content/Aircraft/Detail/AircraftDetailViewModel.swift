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
    
    init(aircraftId: NSManagedObjectID) {
        self.aircraftId = aircraftId
        self.aircraft = Aircraft.byId(id: aircraftId) ?? Aircraft.dummyData
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sectionChanged),
                                               name: Notification.Name.sectionChanged,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.sectionChanged,
                                                  object: nil)
    }
    
    @objc func sectionChanged() {
        aircraftId = nil
    }
    
    func reloadData() {
        self.aircraft = Aircraft.byId(id: aircraft.objectID) ?? Aircraft.dummyData
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

