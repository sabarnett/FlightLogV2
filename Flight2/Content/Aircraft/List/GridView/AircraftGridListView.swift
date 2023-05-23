//
// File: AircraftGridListView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftGridListView: View {
    
    @ObservedObject var vm: AircraftListViewModel
    
    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 2)
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: gridColumns) {
                ForEach(vm.aircraftList, id: \.id) { aircraft in
                    NavigationLink(destination: LazyLoadedView {
                        AircraftDetailView(vm: AircraftDetailViewModel(aircraft: aircraft))
                    },
                    label: {
                        AircraftGridCellView(aircraft: aircraft)
                    })
                    .tag(aircraft.id)
                }
            }.listStyle(.plain)
            
            Spacer()
        }
    }
}

struct AircraftGridListView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftGridListView(vm: AircraftListViewModel())
    }
}
