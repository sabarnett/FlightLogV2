// File: BaseModel.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 08/11/2022
//
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import Foundation
import CoreData

protocol BaseModel: NSManagedObject {
    
    func save()
    
    static func byId<T: NSManagedObject>(id: NSManagedObjectID) -> T?
    static func all<T: NSManagedObject>() -> [T]
    static func allNotDeleted<T: NSManagedObject>() -> [T]
    static func create<T: NSManagedObject>() -> T
}

extension BaseModel {

    static var viewContext: NSManagedObjectContext {
        StorageProvider.shared.context
    }

    func save() {
        do {
                try Self.viewContext.save()
        } catch {
            Self.viewContext.rollback()
            print("Save failed, error: \(error)")
        }
    }
    
    static func all<T>() -> [T] where T: NSManagedObject {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func allNotDeleted<T>() -> [T] where T: NSManagedObject {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        fetchRequest.predicate = NSPredicate(format: "deletedDate = nil")
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    static func byId<T>(id: NSManagedObjectID) -> T? where T: NSManagedObject {
        do {
            return try viewContext.existingObject(with: id) as? T
        } catch {
            print(error)
            return nil
        }
    }
    
    static func create<T>() -> T where T: NSManagedObject {
        return T(context: viewContext) as T
    }
}
