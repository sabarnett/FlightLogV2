//
// File: FlightList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct FlightList: View {
    
    @AppStorage("showDeletedFlights") var showDeletedFlights: Bool = false
    @AppStorage("GroupedBy") var groupFlightsBy: GroupFlightsBy = .pilot
    @AppStorage("FlightPeriod") var flightAgeFilter: FlightAgeSelection = .lastMonth
    
    @StateObject private var vm = FlightListViewModel()
    
    @State private var selectedFlight: String?
    @State private var showAdd: Bool = false
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ListTitleBar(title: "Flights",
                             iconName: "airplane.departure",
                             additionalButtons: additionalButtons())
                
                Text("TODO: List of primary key")
//                List(vm.flights, id: \.self, selection: $vm.selectedFlight) { flight in
//                    NavigationLink(flight, value: flight)
//                }
//                .listStyle(.plain)
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
        .sheet(isPresented: $showAdd, onDismiss: {
            vm.refreshData()
        }) {
            FlightEdit(editViewModel: FlightEditViewModel(flightID: nil))
        }
//        .sheet(isPresented: $showFilters, onDismiss: {
//            vm.refreshData()
//        }) {
//            FlightListFilterView(vm: vm)
//        }
        .onAppear { vm.refreshData(forceLoad: true) }
        .onChange(of: vm.showDeleted) { _ in vm.refreshData(forceLoad: true) }
        .onChange(of: vm.groupBy) { _ in vm.refreshData() }
        .onChange(of: vm.ageFilter) { _ in vm.refreshData() }
        .onChange(of: vm.showActiveFlights) { _ in vm.refreshData() }
//        .onChange(of: searchFor) { _ in vm.searchFor = self.searchFor }
    }
    
    
    func additionalButtons() -> [AdditionalToolbarButton] {
        var buttons: [AdditionalToolbarButton] = []
        buttons.append(showFilterButton())
        buttons.append(addFlightButton())
        
        return buttons
    }

    func addFlightButton() -> AdditionalToolbarButton {
        return AdditionalToolbarButton(image: Image(systemName: "plus")) {
            showAdd.toggle()
        }
    }
    
    func showFilterButton() -> AdditionalToolbarButton {
        AdditionalToolbarButton(image: Image(systemName: "slider.horizontal.3")) {
            print("showFilters")
        }
    }
}

//struct FlightList_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightList()
//    }
//}
