//
// File: PilotList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct PilotList: View {
    
    @StateObject private var vm: PilotsListViewModel = PilotsListViewModel()
    @State private var viewStyle: ViewStyleToggle = .list
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ListTitleBar(title: "Pilots",
                             iconName: "person.fill",
                             additionalButtons: additionalButtons())
                
                if !vm.hasPilots {
                    PlaceHolderView(image: "person-placeholder",
                                    prompt: "Select + to add a pilot")
                } else {
                    List(vm.pilotList, id: \.self, selection: $vm.selectedPilot) { pilot in
                        NavigationLink(value: pilot) {
                            PilotListCellView(pilot: pilot)
                        }.tag(pilot.id)
                    }
                    .listStyle(.plain)
                }
            }
        } detail: {
            if let selectedPilot = vm.selectedPilot {
                PilotDetailView(pilotId: selectedPilot)
            } else {
                Text("Please select a pilot")
            }
        }
        .onAppear {
            vm.loadPilots()
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
            print("add")
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
