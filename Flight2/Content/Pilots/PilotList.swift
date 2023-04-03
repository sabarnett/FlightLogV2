//
// File: PilotList.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        

import SwiftUI

struct PilotList: View {
    
    private var pilots = ["Pilot1", "Pilot2", "Pilot3"]
    @State private var selectedPilot: String?
    @State private var viewStyle: ViewStyleToggle = .list
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                ListTitleBar(title: "Pilots",
                             iconName: "person.fill",
                             additionalButtons: [
                                toggleStateButton()
                             ])
                
                List(pilots, id: \.self, selection: $selectedPilot) { pilot in
                    NavigationLink(pilot, value: pilot)
                }
                .listStyle(.plain)
            }
        } detail: {
            if let selectedPilot {
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
