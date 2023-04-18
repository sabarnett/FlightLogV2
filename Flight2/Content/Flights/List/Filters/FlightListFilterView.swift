//
// File: FlightListFilterView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 09/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightListFilterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var vm: FlightListViewModel
    
    @State var groupBy: GroupFlightsBy = .pilot
    @State var ageFilter: FlightAgeSelection = .lastMonth
    @State var limitTo: String = ""
    @State var showActiveOnly: Bool = false

    var body: some View {
        NavigationView {   
            Form {
                Section("Show") {
                    Toggle("Active Flights Only", isOn: $showActiveOnly)
                }
                
                Section("Filters") {
                    Picker("Group By", selection: $groupBy) {
                        ForEach(GroupFlightsBy.allCases, id: \.self) { grouping in
                            Text(grouping.description).tag(grouping)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                    Picker("Include flights for", selection: $ageFilter) {
                        ForEach(FlightAgeSelection.allCases, id: \.self) { age in
                            Text(age.description).tag(age)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                    Picker("Limit to", selection: $limitTo) {
                        Text("All").tag("All")
                        ForEach(vm.groupNames(for: groupBy).sorted(by: {$0 < $1}), id: \.self) { group in
                            Text(group).tag(group)
                        }
                    }
                }
                
                Button(role: .none, action: {
                    updateAndClose()
                }, label: {
                    Text("Apply")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemGreen))
                    
            }
            .padding(.top, 20)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    dismiss()
                }, label: {
                    XDismissButton()
                })
            }
            .navigationTitle("Flight Filters")
            .navigationBarHidden(true)
        }
        .onAppear {
            groupBy = vm.groupBy
            ageFilter = vm.ageFilter
            limitTo = vm.selectGroup
            showActiveOnly = vm.showActiveFlights
        }
    }
    
    fileprivate func updateAndClose() {
        if groupBy != vm.groupBy { vm.groupBy = groupBy }
        if ageFilter != vm.ageFilter { vm.ageFilter = ageFilter }
        if limitTo != vm.selectGroup { vm.selectGroup = limitTo }
        if showActiveOnly != vm.showActiveFlights { vm.showActiveFlights = showActiveOnly}
        
        dismiss()
    }
}

struct FlightListFilterView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListFilterView(vm: FlightListViewModel())
    }
}
