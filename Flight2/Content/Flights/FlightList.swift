//
// File: FlightList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct FlightList: View {
    
    private var flights = ["Roud the field", "Over The Hill", "Far Away"]
    @State private var selectedFlight: String?
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ListTitleBar(title: "Flights",
                             iconName: "airplane.departure",
                             additionalButtons: [
                                showFilterButton()
                             ])
                
                List(flights, id: \.self, selection: $selectedFlight) { flight in
                    NavigationLink(flight, value: flight)
                }
                .listStyle(.plain)
            }
        } detail: {
            if let selectedFlight {
                Text("Selected Flight: \(selectedFlight)")
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
                Text("Please select a flight")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Add") { print("Add selected") }
                            .foregroundColor(.toolbarIcon)
                    }
                }
            }
        }
    }
    
    func showFilterButton() -> AdditionalToolbarButton {
        AdditionalToolbarButton(image: Image(systemName: "slider.horizontal.3")) {
            print("showFilters")
        }
    }
}

struct FlightList_Previews: PreviewProvider {
    static var previews: some View {
        FlightList()
    }
}
