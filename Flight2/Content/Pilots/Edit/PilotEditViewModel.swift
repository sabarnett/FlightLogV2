//
// File: PilotEditViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 06/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class PilotEditViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var caaRegistration: String = ""
    @Published var address: String = ""
    @Published var postCode: String = ""
    @Published var homePhone: String = ""
    @Published var mobilePhone: String = ""
    @Published var email: String = ""
    @Published var profilePicture: UIImage = UIImage()
    @Published var biography: String = ""
    
    private var pilotId: NSManagedObjectID?
    
    private var errors: [String] = []
    var errorDigest: String {
        return errors.joined(separator: "\n")
    }
    var hasErrors: Bool {
        return !errors.isEmpty
    }
    
    init(pilotID: NSManagedObjectID?) {
        if let pilotID {
            // Load the pilot and the data
            self.pilotId = pilotID
            let pilot = Pilot.byId(id: pilotID) ?? Pilot.dummyData
            
            firstName = pilot.firstName ?? ""
            lastName = pilot.lastName ?? ""
            caaRegistration = pilot.caaRegistration ?? ""
            address = pilot.address ?? ""
            postCode = pilot.postCode ?? ""
            homePhone = pilot.homePhone ?? ""
            mobilePhone = pilot.mobilePhone ?? ""
            email = pilot.email ?? ""
            biography = pilot.biography ?? ""
            
            // Empty profile image
            profilePicture = pilot.profileImage?.image ?? UIImage()

        } else {
            // New pilot - use the default values
            self.pilotId = nil
        }
    }
    
    func save() {
        var pilot: Pilot
        
        if let pilotId {
            pilot = Pilot.byId(id: pilotId) as! Pilot
        } else {
            pilot = Pilot.create()
            pilot.deletedDate = nil
        }
        
        pilot.firstName = firstName
        pilot.lastName = lastName
        pilot.caaRegistration = caaRegistration
        pilot.address = address
        pilot.postCode = postCode
        pilot.homePhone = homePhone
        pilot.mobilePhone = mobilePhone
        pilot.email = email
        pilot.biography = biography
        
        if profilePicture.size.width == 0 {
            pilot.clearProfileImage()
        } else {
            pilot.setProfileImage(profilePicture)
        }
        
        pilot.save()
        
        MessageCenter.send(Notification.Name.pilotUpdated, withData: pilot.objectID)
    }
    
    func canSave() -> Bool {
        errors = []
        
        if Validators.isRequiredFieldEmpty(firstName) { errors.append("First Name is required") }
        if Validators.isRequiredFieldEmpty(lastName) { errors.append("Last Name is required") }
        if Validators.isRequiredFieldEmpty(caaRegistration) { errors.append("CAA Registration is required") }
        
        if !Validators.isValidEmail(email) { errors.append("Invalid email address")}

        return errors.isEmpty
    }
}
