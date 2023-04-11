//
// File: Aircraft+Extensions.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import UtilityViews

class AircraftSearchOptions: SearchOptionsBase {
    // Additional options here please.
}

extension Aircraft {
    
    var viewName: String { self.name ?? "" }
    var viewManufacturer: String { self.manufacturer ?? "" }
    var viewModel: String { self.model ?? "" }
    var viewNotes: String { self.notes ?? "" }
    var viewSerialNumber: String { self.serialNumber ?? "" }
    var viewPurchasedFrom: String { self.purchasedFrom ?? "" }
    var viewPurchaseDate: Date { self.purchaseDate ?? Date() }    // TODO: Blank date???
    var viewNewAtPurchase: String { self.newAtPurchase == true ? "Yes" : "No" }
    var viewAircraftImage: UIImage { self.aircraftImage?.image ?? UIImage(named: "aircraft-placeholder")!}
    
    var aircraftDeleted: Bool { self.deletedDate != nil }
    
}

extension Aircraft: BaseModel {
    
    // MARK: - Public interface - static methods
    
    static func all() -> [Aircraft] { return fetchAircraft(withOptions: AircraftSearchOptions()) }
    static func all(withOptions: AircraftSearchOptions) -> [Aircraft] { return fetchAircraft(withOptions: withOptions) }

    static func count() -> Int {
        let fetchRequest: NSFetchRequest<Aircraft> = Aircraft.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        fetchRequest.resultType = .countResultType
        
        do {
            return try StorageProvider.shared.context.count(for: fetchRequest)
        } catch {
            return 0
        }
    }

    static func pickerData() -> [PickerOption] {
        
        let fetchRequest: NSFetchRequest<Aircraft> = Aircraft.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Aircraft.manufacturer), ascending: true),
            NSSortDescriptor(key: #keyPath(Aircraft.name), ascending: true)
        ]
               
//        fetchRequest.propertiesToFetch = [
//            #keyPath(Aircraft.manufacturer),
//            #keyPath(Aircraft.name),
//            #keyPath(Aircraft.aircraftImage),
//            #keyPath(Aircraft.manufacturer)
//        ]
        
        do {
            return try StorageProvider.shared.context.fetch(fetchRequest).map { aircraft in
                PickerOptionWithKey(image: aircraft.aircraftImage?.image,
                                    title: aircraft.name ?? "",
                                    subTitle: aircraft.manufacturer ?? "",
                                    managedObjectID: aircraft.objectID )
            }
        } catch {
            return []
        }
    }
    
    // MARK: - Helper properties
    var hasPurchaseData: Bool {
        if let purchasedFrom {
            return purchasedFrom.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        }
        return false
    }
    
    var formattedPurchaseDate: String {
        if let purchaseDate {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .none
            return df.string(from: purchaseDate)
        }
        return ""
    }
    
    // MARK: - Public helper methods
    
    /// Deletes the profile picture associated with the current pilot instanmce. The profileImage will be
    /// reset in the pilot object and the picture wioll be deleted from the SavedImages table.
    func clearAircraftImage() {
        guard let aircraftPicture = self.aircraftImage else { return }

        // Delete the existing image
        StorageProvider.shared.context.delete(aircraftPicture)
        aircraftImage = nil
    }
    
    /// Adds or updates thge profileImage for this pilot. If there was already a profile image, the picture
    /// will be replaced. If there is no existing profile image, a new SavedImage will be created and attached
    /// to the pilot.
    ///
    /// The image itself will not be saved in this code. It is assumed that the context will be saved later.
    ///
    /// - Parameter image: The UIImage to be associated with the pilot
    func setAircraftImage(_ image: UIImage) {
        if let aircraftPicture = aircraftImage {
            // Existing image, so update it.
            aircraftPicture.image = image
            return
        }
        
        let newImage = SavedImage(context: StorageProvider.shared.context)
        newImage.image = image
        aircraftImage = newImage
    }
    
    
    // MARK: - Private Helper functions
    fileprivate static func fetchAircraft(withOptions options: AircraftSearchOptions) -> [Aircraft] {
        
        let fetchRequest: NSFetchRequest<Aircraft> = Aircraft.fetchRequest()
        
        if !options.includeDeleted {
            fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Aircraft.manufacturer), ascending: true),
            NSSortDescriptor(key: #keyPath(Aircraft.name), ascending: true)
        ]
        
        if let searchFor = options.textSearch, searchFor.count > 0 {
            // We have search text!
            let searchName = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Aircraft.name), searchFor)
            let searchManufacturer = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Aircraft.manufacturer), searchFor)
            let searchModel = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Aircraft.model), searchFor)

            let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                searchName,
                searchManufacturer,
                searchModel])
            
            fetchRequest.predicate = searchPredicate
        }
        
        do {
            return try StorageProvider.shared.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    // MARK: - Dummy data for preview usage
    static var dummyData: Aircraft {
        let aircraft = Aircraft.create() as Aircraft

        aircraft.manufacturer = "Manufacturer"
        aircraft.model = "Aircraft model"
        aircraft.name = "Aircraft Name"
        aircraft.newAtPurchase = true
        aircraft.notes = "Sample aircraft data.\nCreated to allow testing to be done on views and in code.\nNot for general use."
        aircraft.purchaseDate = Date()
        aircraft.purchasedFrom = "eBay"
        aircraft.serialNumber = "AIR-000-12345"
        aircraft.aircraftImage = nil
        
        return aircraft
    }
}
