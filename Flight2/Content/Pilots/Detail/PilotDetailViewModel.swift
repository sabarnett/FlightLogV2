//
// File: PilotDetailViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class PilotDetailViewModel: ObservableObject {
    
    @Published var pilot: Pilot
    @Published var pilotId: NSManagedObjectID?
    
    init(pilot: Pilot) {
        self.pilotId = pilot.objectID
        self.pilot = pilot
        
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
        pilotId = nil
    }
    
    func reloadData() {
        StorageProvider.shared.context.refresh(pilot, mergeChanges: true)
    }
    
    func deletePilot() {
        setDeletedState(forPilot: self.pilot, isDeleted: true)
    }
    
    func undeletePilot() {
        setDeletedState(forPilot: self.pilot, isDeleted: false)
    }
    
    private func setDeletedState(forPilot pilot: Pilot, isDeleted: Bool) {
        pilot.deletedDate = isDeleted ? Date() : nil
        pilot.save()
    }
}
