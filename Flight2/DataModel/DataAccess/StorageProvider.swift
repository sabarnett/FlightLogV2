//
// File: StorageProvider.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 08/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//
        

import Foundation
import CoreData

class StorageProvider {
    
    static let shared: StorageProvider = StorageProvider()
    
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "db")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores() { description, error in
            if let error {
                fatalError("Failed to load data store: \(error)")
            }
        }
        
        let directory = NSPersistentContainer.defaultDirectoryURL()
        let url = directory.appendingPathComponent("UIImageTransformer" + ".sqlite")
        print("********************************************")
        print(url)
        print("********************************************")
    }
}
