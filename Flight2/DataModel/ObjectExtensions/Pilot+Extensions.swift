//
// File: Pilot+Extensions.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 08/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//
        

import Foundation
import CoreData
import SwiftUI
import UtilityViews

class PilotSearchOptions: SearchOptionsBase {
    // Additional options here please.
}

extension Pilot: BaseModel {
    
    // MARK: - Public interface - static methods
    
    static func all() -> [Pilot] { return fetchPilots(withOptions: PilotSearchOptions()) }
    static func all(withOptions: PilotSearchOptions) -> [Pilot] { return fetchPilots(withOptions: withOptions) }

    static func count() -> Int {
        let fetchRequest: NSFetchRequest<Pilot> = Pilot.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        fetchRequest.resultType = .countResultType
        
        do {
            return try StorageProvider.shared.context.count(for: fetchRequest)
        } catch {
            return 0
        }
    }
    
    static func pickerData() -> [PickerOption] {
        let fetchRequest: NSFetchRequest<Pilot> = Pilot.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Pilot.lastName), ascending: true),
            NSSortDescriptor(key: #keyPath(Pilot.firstName), ascending: true)
        ]
        
        do {
            return try StorageProvider.shared.context.fetch(fetchRequest).map { pilot in
                PickerOptionWithKey(image: pilot.profileImage?.image,
                                    title: pilot.displayName,
                                    subTitle: pilot.caaRegistration ?? "",
                                    managedObjectID: pilot.objectID)
            }
        } catch {
            return []
        }
    }
    
    var displayName: String {
        "\(lastName ?? ""), \(firstName ?? "")"
    }
    
    // MARK: - Public helper methods
    
    /// Deletes the profile picture associated with the current pilot instanmce. The profileImage will be
    /// reset in the pilot object and the picture wioll be deleted from the SavedImages table.
    func clearProfileImage() {
        guard let profilePicture = self.profileImage else { return }

        // Delete the existing image
        StorageProvider.shared.context.delete(profilePicture)
        profileImage = nil
    }
    
    /// Adds or updates thge profileImage for this pilot. If there was already a profile image, the picture
    /// will be replaced. If there is no existing profile image, a new SavedImage will be created and attached
    /// to the pilot.
    ///
    /// The image itself will not be saved in this code. It is assumed that the context will be saved later.
    ///
    /// - Parameter image: The UIImage to be associated with the pilot
    func setProfileImage(_ image: UIImage) {
        if let profilePicture = profileImage {
            // Existing image, so update it.
            profilePicture.image = image
            return
        }
        
        let newImage = SavedImage(context: StorageProvider.shared.context)
        newImage.image = image
        profileImage = newImage
    }
    
    
    // MARK: - Private Helper functions
    fileprivate static func fetchPilots(withOptions options: PilotSearchOptions) -> [Pilot] {
        
        let fetchRequest: NSFetchRequest<Pilot> = Pilot.fetchRequest()
        
        if !options.includeDeleted {
            fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Pilot.lastName), ascending: true),
            NSSortDescriptor(key: #keyPath(Pilot.firstName), ascending: true)
        ]
        
        if let searchFor = options.textSearch, searchFor.count > 0 {
            // We have search text!
            let searchFirstName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.firstName), searchFor)
            let searchLastName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.lastName), searchFor)
            let searchAddress = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.address), searchFor)
            let searchMobile = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Pilot.mobilePhone), searchFor)

            let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                searchFirstName,
                searchLastName,
                searchAddress,
                searchMobile])
            
            fetchRequest.predicate = searchPredicate
        }
        
        do {
            return try StorageProvider.shared.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    // MARK: - Dummy data for preview usage
    static var dummyData: Pilot {
        let pilot = Pilot.create() as Pilot

        pilot.firstName = "Dummy"
        pilot.lastName = "Pilot"
        pilot.caaRegistration = "AAA-BBBBBBBB-CCCC"
        pilot.mobilePhone = "07910 111 222"
        pilot.homePhone = "0121 222 3333"
        pilot.email = "dummy@example.com"
        pilot.address = "Line 1\nLine 2\nLine 3"
        pilot.postCode = "V12 7RR"
        pilot.profileImage = nil
        
        return pilot
    }
}
