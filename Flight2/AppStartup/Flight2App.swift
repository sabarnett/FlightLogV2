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
    
    var body: some Scene {
        WindowGroup {
            FlightLogHome()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
