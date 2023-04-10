//
// File: ContentView.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct FlightLogHome: View {
    var body: some View {
        NavigationStack {
            TabView {
                PilotList()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Pilots")
                    }
                
                AircraftList()
                    .tabItem {
                        Image(systemName: "airplane")
                        Text("Aircraft")
                    }
                
                FlightList()
                    .tabItem {
                        Image(systemName: "airplane.departure")
                        Text("Flights")
                    }
            }
        }
        .onAppear {
            // correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
            // correct the transparency bug for Navigation bars
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
}

struct FlightLogHome_Previews: PreviewProvider {
    static var previews: some View {
        FlightLogHome()
    }
}
