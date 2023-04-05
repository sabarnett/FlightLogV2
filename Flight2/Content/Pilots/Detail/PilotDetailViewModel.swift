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
    
    init(pilotId: NSManagedObjectID) {
        self.pilotId = pilotId
        self.pilot = Pilot.byId(id: pilotId) ?? Pilot.dummyData
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
    
    var firstName: String { pilot.firstName ?? "" }
    var lastName: String { pilot.lastName ?? "" }
    var caaRegistration: String { pilot.caaRegistration ?? "" }
    var homePhone: String { pilot.homePhone ?? "" }
    var mobilePhone: String { pilot.mobilePhone ?? "" }
    var address: String { pilot.address ?? "" }
    var postcode: String { pilot.postCode ?? "" }
    var email: String { pilot.email ?? "" }
    
    var profilePicture: UIImage { pilot.profileImage?.image ?? UIImage(imageLiteralResourceName: "person-placeholder") }
    var isDeleted: Bool { pilot.deletedDate != nil }
    
    func reloadData() {
        self.pilot = Pilot.byId(id: pilot.objectID) ?? Pilot.dummyData
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
