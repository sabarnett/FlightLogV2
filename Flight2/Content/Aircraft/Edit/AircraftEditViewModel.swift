//
// File: AircraftEditViewModel.swift
// Package: Flight2
// Created by: Steven Barnett on 10/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import Foundation
import CoreData
import SwiftUI

class AircraftEditViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var manufacturer: String = ""
    @Published var model: String = ""
    @Published var serialNumber: String = ""
    @Published var notes: String = ""
    @Published var purchasedFrom: String = ""
    @Published var purchasedDate: Date?
    @Published var purchasedNew: Bool = true
    @Published var aircraftImage: UIImage = UIImage()
    
    private var aircraftId: NSManagedObjectID?
    
    private var errors: [String] = []
    var errorDigest: String {
        return errors.joined(separator: "\n")
    }
    var hasErrors: Bool {
        return !errors.isEmpty
    }
    
    init(aircraftID: NSManagedObjectID?) {
        if let aircraftID {
            // Load the pilot and the data
            self.aircraftId = aircraftID
            let aircraft = Aircraft.byId(id: aircraftID) ?? Aircraft.dummyData
            
            name = aircraft.name ?? ""
            manufacturer = aircraft.manufacturer ?? ""
            model = aircraft.model ?? ""
            serialNumber = aircraft.serialNumber ?? ""
            notes = aircraft.notes ?? ""
            purchasedFrom = aircraft.purchasedFrom ?? ""
            purchasedDate = aircraft.purchaseDate ?? Date()
            purchasedNew = aircraft.newAtPurchase
            
            // Empty profile image
            aircraftImage = aircraft.aircraftImage?.image ?? UIImage()

        } else {
            // Initialise the fields
            name = ""
            manufacturer =  ""
            model =  ""
            serialNumber =  ""
            notes =  ""
            purchasedFrom = ""
            purchasedDate =  Date()
            purchasedNew = true
            
            // Empty profile image
            aircraftImage = UIImage()

            self.aircraftId = nil
        }
    }
    
    func cancel() {
        if StorageProvider.shared.context.hasChanges {
            StorageProvider.shared.context.rollback()
        }
    }
    
    func save() {
        var aircraft: Aircraft
        
        if let aircraftId {
            aircraft = Aircraft.byId(id: aircraftId) as! Aircraft
        } else {
            aircraft = Aircraft.create()
            aircraft.deletedDate = nil
        }
        
        aircraft.name = name
        aircraft.manufacturer = manufacturer
        aircraft.model = model
        aircraft.serialNumber = serialNumber
        aircraft.notes = notes
        aircraft.purchasedFrom = purchasedFrom
        aircraft.purchaseDate = purchasedDate
        aircraft.newAtPurchase = purchasedNew
        
        if aircraftImage.size.width == 0 {
            aircraft.clearAircraftImage()
        } else {
            aircraft.setAircraftImage(aircraftImage)
        }
        
//        var maintLog1 = AircraftMaintenance(context: StorageProvider.shared.context)
//        maintLog1.title = "Repair paintwork"
//        maintLog1.actionDate = Date.now
//        maintLog1.action = "Paintwork was damaged in transit. The aircraft was sanded down and repainted to restore the original colour."
//        maintLog1.maintenance = aircraft
//        
//        var maintLog2 = AircraftMaintenance(context: StorageProvider.shared.context)
//        maintLog2.title = "Charge battery"
//        maintLog2.actionDate = Date.now
//        maintLog2.action = "Replaced battery with a new, higher capacity, model. This needs to be charged for a minmum of 12 hours bvefore the next flight."
//        maintLog2.maintenance = aircraft

        aircraft.save()
        
        MessageCenter.send(Notification.Name.aircraftUpdated, withData: aircraft.objectID)
    }
    
    func canSave() -> Bool {
        errors = []
        
        if Validators.isRequiredFieldEmpty(name) { errors.append("Aircraft require a name")}
        if Validators.isRequiredFieldEmpty(manufacturer) { errors.append("Manufacturer missing")}
        if Validators.isRequiredFieldEmpty(model) { errors.append("Model missing")}

        return errors.isEmpty
    }
    
    func hasPurchaseLocation() -> Bool {
        purchasedFrom.trimmingCharacters(in: .whitespacesAndNewlines).count != 0
    }
}
