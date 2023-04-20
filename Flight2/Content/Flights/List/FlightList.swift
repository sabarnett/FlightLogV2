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
    @State private var showFilters: Bool = false
    @State private var showEdit: Bool = false
    @State private var columnsVisible: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnsVisible, sidebar: {
            VStack(spacing: 0) {
                ListTitleBar(title: "Flights",
                             iconName: "airplane.departure",
                             additionalButtons: additionalButtons())
                
                List(vm.primaryList, id: \.objectID, selection: $vm.primarySelection) { flight in
                    FlightPrimaryListCell(flight: flight, groupedBy: vm.groupBy)
                        .tag(flight.objectID)
                }
                .listStyle(.plain)
                .id(vm.primaryListId)
            }
        }, content: {
            if vm.primarySelection != nil {
                List(vm.secondaryList, id: \.objectID, selection: $vm.secondarySelection) { flight in
                    FlightSecondaryListCell(flight: flight, groupedBy: vm.groupedByOpposite)
                        .tag(flight.objectID)
                }
            } else {
                Text(vm.groupBy == .pilot ? "Please select a pilot" : "Please sleect an aircraft")
            }
        }, detail: {
            if vm.secondarySelection != nil {
                FlightDetailView(vm: FlightDetailViewModel(flight: vm.selectedFlight))
            } else {
                Text("Select a flight")
            }
        })
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $showAdd,
            onDismiss: {
            vm.refreshData()
        }, content: {
            FlightEdit(editViewModel: FlightEditViewModel(flightID: nil))
        })
        .sheet(isPresented: $showFilters,
               onDismiss: {
            vm.refreshData()
        }, content: {
            FlightListFilterView(vm: vm)
        })
        .onAppear { vm.refreshData(forceLoad: true) }
        .onChange(of: vm.showDeleted) { _ in vm.refreshData(forceLoad: true) }
        .onChange(of: vm.groupBy) { _ in vm.refreshData() }
        .onChange(of: vm.ageFilter) { _ in vm.refreshData() }
        .onChange(of: vm.showActiveFlights) { _ in vm.refreshData() }
//        .onChange(of: searchFor) { _ in vm.searchFor = self.searchFor }
        .onChange(of: vm.primarySelection) { _ in
            vm.secondarySelection = nil
        }
        .onChange(of: vm.secondarySelection) { _ in
            if vm.secondarySelection == nil {
                columnsVisible = .all
            } else {
                columnsVisible = .doubleColumn
            }
        }
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
            showFilters.toggle()
        }
    }
    
    func deleteFlight() {
        
    }
}

//struct FlightList_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightList()
//    }
//}
