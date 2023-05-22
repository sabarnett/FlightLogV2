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
    @AppStorage("displayPilotsAs") var displayPilotsAs: ViewStyleToggle = .list

    @StateObject private var vm: PilotsListViewModel = PilotsListViewModel()
    @State private var showAdd: Bool = false

    var body: some View {
        NavigationSplitView (sidebar: {
            VStack {
                ListTitleBar(title: $vm.listTitle,
                             iconName: $vm.listIcon,
                             additionalButtons: additionalButtons())
                
                if !vm.hasPilots {
                    PlaceHolderView(image: "person-placeholder",
                                    prompt: "Select + to add a pilot")
                } else {
                    switch displayPilotsAs {
                    case .list:
                        PilotListView(vm: vm)
                        
                    case .card:
                        PilotCardListView(viewModel: vm)
                        
                    case .grid:
                        PilotGridListView(viewModel: vm)
                    }
                }
            }

        }, detail: {
            if let selectedPilot = vm.selectedPilot {
                PilotDetailView(vm: PilotDetailViewModel(pilot: selectedPilot))
            } else {
                NothingSelectedView(prompt: "Please select or add a pilot")
            }
        })
        .onAppear { vm.loadPilots(includeDeleted: showDeleted) }
        .onChange(of: showDeleted, perform: { _ in vm.loadPilots(includeDeleted: showDeleted) })
        .sheet(isPresented: $showAdd, onDismiss: {
            vm.loadPilots(includeDeleted: showDeleted)
        }, content: {
            PilotEdit(editViewModel: PilotEditViewModel(pilotID: nil))
        })
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
            image: Image(systemName: displayPilotsAs.nextStyle.imageName)) {
                displayPilotsAs = displayPilotsAs.nextStyle
            }
    }
}

struct PilotList_Previews: PreviewProvider {
    static var previews: some View {
        PilotList()
    }
}
