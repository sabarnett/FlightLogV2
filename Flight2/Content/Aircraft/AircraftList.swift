//
// File: AirctaftList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct AircraftList: View {
    
    private var aircraft = ["Plane 1", "Drone", "UAV 1", "UAV 2",
                            "Plane 1", "Drone", "UAV 1", "UAV 2",
                            "Plane 1", "Drone", "UAV 1", "UAV 2",
                            "Plane 1", "Drone", "UAV 1", "UAV 2",
                            "Plane 1", "Drone", "UAV 1", "UAV 2",
                            "Plane 1", "Drone", "UAV 1", "UAV 2"]
    @State private var selectedAircraft: String?
    @State private var viewStyle: ViewStyleToggle = .list
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ListTitleBar(title: "Aircraft", iconName: "airplane",
                             additionalButtons: [
                                toggleStateButton()
                             ])
                
                List(aircraft, id: \.self, selection: $selectedAircraft) { aircraft in
                    NavigationLink(aircraft, value: aircraft)
                }
                .listStyle(.plain)
            }
        } detail: {
            if let selectedAircraft {
                Text("Selected Pilot: \(selectedAircraft)")
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            HStack {
                                Button("AA") { print("AA selected") }
                                Button("BB") { print("BB selected") }
                            }
                            .foregroundColor(.toolbarIcon)
                        }
                    }
            } else {
                Text("Please select an aircraft")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button("Add") { print("Add selected") }
                            .foregroundColor(.toolbarIcon)
                    }
                }
            }
        }
    }
    
    func toggleStateButton() -> AdditionalToolbarButton {
        return AdditionalToolbarButton(
            image: Image(systemName: viewStyle.imageName)) {
                viewStyle = viewStyle.nextStyle
        }
    }
}

struct AircraftList_Previews: PreviewProvider {
    static var previews: some View {
        AircraftList()
    }
}
