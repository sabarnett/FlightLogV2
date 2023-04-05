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
                        NavigationLink(pilot.displayName, value: pilot)
                            .tag(pilot.id)
                    }
                    .listStyle(.plain)
                }
            }
        } detail: {
            if let selectedPilot = vm.selectedPilot {
                Text("Selected Pilot: \(selectedPilot)")
                    .toolbar {
                        ToolbarItemGroup(placement: .primaryAction) {
                            HStack {
                                Button(action: {
                                    print("Add new")
                                }, label: {
                                    Image(systemName: "plus")
                                })
                                
                                Button( action: {
                                    print("Delete")
                                }, label: {
                                    Image(systemName: "trash")
                                })
                            }
                            .foregroundColor(.toolbarIcon)
                        }
                    }
            } else {
                Text("Please select a pilot")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(action: {
                            print("Add new")
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .foregroundColor(.toolbarIcon)

                    }
                }
            }
        }
        .onAppear {
            vm.loadPilots()
        }
    }
    
    func additionalButtons() -> [AdditionalToolbarButton] {
        var buttons: [AdditionalToolbarButton] = []
        buttons.append(toggleStateButton())
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            // Phone dev ices will need an add button
            let addButton = AdditionalToolbarButton(image: Image(systemName: "plus")) {
                print("add")
            }
            buttons.append(addButton)
        }
        
        return buttons
    }
    
    func toggleStateButton() -> AdditionalToolbarButton {
        return AdditionalToolbarButton(
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
