//
// File: AirctaftList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AircraftList: View {
    
    @AppStorage("showDeletedAircraft") var showDeleted: Bool = false
    @AppStorage("displayAircraftAs") var displayAircraftAs: ViewStyleToggle = .card
    
    @StateObject private var vm: AircraftListViewModel = AircraftListViewModel()
    @State private var viewStyle: ViewStyleToggle = .list
    @State private var showAdd: Bool = false
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ListTitleBar(title: "Aircraft", iconName: "airplane",
                             additionalButtons: additionalButtons())
                
                if !vm.hasAircraft {
                    PlaceHolderView(image: "aircraft-placeholder",
                                    prompt: "Select + to add an aircraft")
                } else {
                    
                    List(selection: $vm.selectedAircraftID) {
                        ForEach(vm.aircraftList, id: \.objectID) { aircraft in
                            NavigationLink(value: aircraft.objectID) {
                                AircraftListCellView(aircraft: aircraft)
                            }
                            .tag(aircraft.id)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        } detail: {
            if let selectedAircraft = vm.selectedAircraft {
                AircraftDetailView(vm: AircraftDetailViewModel(aircraft: selectedAircraft))
            } else {
                NothingSelectedView(prompt: "Please select or add an aircraft")
            }
        }
        .onAppear { vm.loadAircraft(includeDeleted: showDeleted) }
        .onChange(of: showDeleted, perform: { _ in vm.loadAircraft(includeDeleted: showDeleted) })
        .sheet(isPresented: $showAdd, onDismiss: {
            vm.loadAircraft(includeDeleted: showDeleted)
        }) {
            AircraftEdit(editViewModel: AircraftEditViewModel(aircraftID: nil))
        }
    }
    
    func additionalButtons() -> [AdditionalToolbarButton] {
        var buttons: [AdditionalToolbarButton] = []
        buttons.append(toggleStateButton())
        buttons.append(addPilotButton())
        
        return buttons
    }

    func addPilotButton() -> AdditionalToolbarButton {
        return AdditionalToolbarButton(image: Image(systemName: "plus")) {
            showAdd.toggle()
        }
    }
    
    func toggleStateButton() -> AdditionalToolbarButton {
        AdditionalToolbarButton(
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
