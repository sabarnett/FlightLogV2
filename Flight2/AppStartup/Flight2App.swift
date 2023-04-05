//
// File: Flight2App.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

@main
struct Flight2App: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    init() {
        loadSamples.loadSamplePilots()
    }
    
    var body: some Scene {
        WindowGroup {
            FlightLogHome()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

class loadSamples {
    
    public static func loadSamplePilots() {

        if Pilot.count() > 0 { return }
        
        let pilot1 = Pilot(context: StorageProvider.shared.context)
        pilot1.firstName = "Maria"
        pilot1.lastName = "Smith"
        pilot1.address = "1, The Cottages\nCottageVille\nCottages"
        pilot1.caaRegistration = "CAA-012456-LWDH"
        pilot1.email = "pilot2@example.com"
        pilot1.setProfileImage(UIImage(named: "person-placeholder")!)
        pilot1.save()
        
        let pilot2 = Pilot(context: StorageProvider.shared.context)
        pilot2.firstName = "Sandra"
        pilot2.lastName = "Dawson"
        pilot2.address = "5, Maltings House\nThe Heights\nBirmingham"
        pilot2.caaRegistration = "CAA-93786-FDSA"
        pilot2.email = "pilot3@example.com"
        pilot2.setProfileImage(UIImage(named: "person-placeholder")!)
        pilot2.save()
    }
}
