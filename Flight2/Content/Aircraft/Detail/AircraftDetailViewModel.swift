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
    
    init(aircraft: Aircraft) {
        self.aircraftId = aircraft.objectID
        self.aircraft = aircraft
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
