//
// File: PilotList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PilotList: View {
    
    @AppStorage("showDeletedPilots") var showDeleted: Bool = false
    @AppStorage("displayPilotsAs") var displayPilotsAs: ViewStyleToggle = .card
    
    @StateObject private var vm: PilotsListViewModel = PilotsListViewModel()
    @State private var viewStyle: ViewStyleToggle = .list
    @State private var showAdd: Bool = false
    
    var body: some View {
        NavigationSplitView {
            VStack {
                ListTitleBar(title: "Pilots",
                             iconName: "person.fill",
                             additionalButtons: additionalButtons())
                
                if !vm.hasPilots {
                    PlaceHolderView(image: "person-placeholder",
                                    prompt: "Select + to add a pilot")
                } else {
                    
                    List(selection: $vm.selectedPilotID) {
                        ForEach(vm.pilotList, id: \.objectID) { pilot in
                            NavigationLink(value: pilot.objectID) {
                                PilotListCellView(pilot: pilot)
                            }
                            .tag(pilot.id)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        } detail: {
            if let selectedPilot = vm.selectedPilot {
                PilotDetailView(vm: PilotDetailViewModel(pilot: selectedPilot))
            } else {
                Text("Please select a pilot")
            }
        }
        .onAppear { vm.loadPilots(includeDeleted: showDeleted) }
        .onChange(of: showDeleted, perform: { _ in vm.loadPilots(includeDeleted: showDeleted) })
        .sheet(isPresented: $showAdd, onDismiss: {
            vm.loadPilots(includeDeleted: showDeleted)
        }) {
            PilotEdit(editViewModel: PilotEditViewModel(pilotID: nil))
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

struct PilotList_Previews: PreviewProvider {
    static var previews: some View {
        PilotList()
    }
}
