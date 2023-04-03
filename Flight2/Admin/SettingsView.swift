//
// File: SettingsView.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("showDeletedPilots") var showDeletedPilots: Bool = false
    @AppStorage("displayPilotsAs") var displayPilotsAs: ViewStyleToggle = .card
    
    @AppStorage("showDeletedAircraft") var showDeletedAircraft: Bool = false
    @AppStorage("displayAircraftAs") var displayAircraftAs: ViewStyleToggle = .card

    @AppStorage("showDeletedFlights") var showDeletedFlights: Bool = false
    @AppStorage("GroupedBy") var groupFlightsBy: GroupFlightsBy = .pilot
    @AppStorage("FlightPeriod") var flightAgeFilter: FlightAgeSelection = .lastMonth
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: SectionTitle("Pilots")) {
                    Toggle(isOn: $showDeletedPilots, label: { Text("Show Deleted Pilots")} )
                    Picker("Display as", selection: $displayPilotsAs) {
                        ForEach(ViewStyleToggle.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.automatic)
                }
                Section(header: SectionTitle("Aircraft")) {
                    Toggle(isOn: $showDeletedAircraft, label: { Text("Show Deleted Aircraft")} )
                    Picker("Display as", selection: $displayAircraftAs) {
                        ForEach(ViewStyleToggle.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.automatic)
                }
                
                Section(header: SectionTitle("Flights")) {
                    Toggle(isOn: $showDeletedFlights, label: { Text("Show Deleted Flights")} )
                    Picker("Group By", selection: $groupFlightsBy) {
                        ForEach(GroupFlightsBy.allCases, id: \.self) { grouping in
                            Text(grouping.description).tag(grouping)
                        }
                    }.pickerStyle(.automatic)
                    Picker("Include flights for", selection: $flightAgeFilter) {
                        ForEach(FlightAgeSelection.allCases, id: \.self) { age in
                            Text(age.description).tag(age)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section(header: SectionTitle("App")) {
                    Toggle(isOn: $isDarkMode, label: {
                        Text("Dark mode")
                    })
                }
            }
            .overlay(alignment: .topTrailing) {
                Button { dismiss() }
                    label: {
                        Image(systemName: "x.circle.fill")
                            .font(Font.body.weight(.bold))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .scaleEffect(1.5)
                        }
            }
            .navigationTitle("Options")
            .navigationBarHidden(true)
        }.preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
