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
    @Published var maintenanceItems: [AircraftMaintenanceModel] = []
    
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
            
            if let maintItems = aircraft.maintenance as? Set<AircraftMaintenance> {
                maintenanceItems = maintItems.map(AircraftMaintenanceModel.init).sorted(by: { lhs, rhs in
                    lhs.actionDate! < rhs.actionDate!
                })
            } else {
                maintenanceItems = []
            }

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
            
            maintenanceItems = []

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
        
        updateMaintenance(forAircraft: aircraft,
                          fromItems: aircraft.maintenance as? Set<AircraftMaintenance>,
                          toItems: maintenanceItems)

        aircraft.save()
        
        MessageCenter.send(Notification.Name.aircraftUpdated, withData: aircraft.objectID)
    }
    
    private func updateMaintenance(forAircraft: Aircraft,
                                   fromItems items: Set<AircraftMaintenance>?,
                                   toItems modifiedItems: [AircraftMaintenanceModel]) {
        
        let itemsToDelete = modifiedItems.filter { item in item.isDeleted && item.id != nil }
        let itemsToAdd = modifiedItems.filter { item in item.id == nil && item.isDeleted == false }
        let itemsToUpdate = modifiedItems.filter { item in item.hasChanged && item.id != nil }
        
        for toDelete in itemsToDelete {
            StorageProvider.shared.context.delete((items?.first(where: {
                $0.objectID == toDelete.maintenanceItem?.objectID
            }))!)
        }
        for toUpdate in itemsToUpdate {
            if let item = items?.first(where: {$0.objectID == toUpdate.maintenanceItem?.objectID}) {
                item.title = toUpdate.title
                item.action = toUpdate.action
                item.actionDate = toUpdate.actionDate
            }
        }
        for toAdd in itemsToAdd {
            let newAction = AircraftMaintenance.create() as AircraftMaintenance
            newAction.title = toAdd.title
            newAction.action = toAdd.action
            newAction.actionDate = toAdd.actionDate
            newAction.maintenance = forAircraft
        }
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

struct AircraftMaintenanceModel: Hashable {
    
    var maintenanceItem: AircraftMaintenance?
    
    var id: NSManagedObjectID? {
        maintenanceItem?.objectID ?? nil
    }
    
    init(maintenanceItem: AircraftMaintenance?) {
        if let maintenanceItem {
            self.maintenanceItem = maintenanceItem
            title = maintenanceItem.viewTitle
            action = maintenanceItem.viewAction
            actionDate = maintenanceItem.actionDate
        } else {
            title = ""
            action = ""
            actionDate = nil
        }
        
        isDeleted = false
    }
    
    var title: String { didSet { listId = UUID() } }
    var action: String { didSet { listId = UUID() } }
    var actionDate: Date? { didSet { listId = UUID() } }
    
    // Used to help rebuild the list when it is saved. We give users the chance to delete an
    // issue, but they get the chance to undelete it right up until they save the data.
    var isDeleted: Bool { didSet { listId = UUID() } }
    
    // Used to force a list refresh. By changing the listId, we force any list to refresh the
    // specific issue. If we don't do this, SwiftUI will reuse the old cell view as it will decide
    // that it hasn't changed.
    var listId: UUID = UUID()
    
    var hasChanged: Bool {
        if title != maintenanceItem?.title { return true }
        if action != maintenanceItem?.action { return true }
        if actionDate != maintenanceItem?.actionDate { return true }
        return false
    }
}
