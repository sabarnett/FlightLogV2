//
// File: PilotGridListView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 12/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct PilotGridListView: View {
    
    @ObservedObject var vm: PilotsListViewModel
    
    init(viewModel: PilotsListViewModel) {
        self.vm = viewModel
    }
    
    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: 2)
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: gridColumns) {
                ForEach(vm.pilotList, id: \.id) { pilot in
                    NavigationLink(destination: LazyLoadedView {
                        PilotDetailView(vm: PilotDetailViewModel(pilot: pilot))
                    },
                    label: {
                        PilotGridCellView(pilot: pilot)
                    })
                    .tag(pilot.id)
                }
            }.listStyle(.plain)
             .id(vm.listRefresh)
            Spacer()
        }
    }
}

struct PilotGridListView_Previews: PreviewProvider {
    static var previews: some View {
        PilotGridListView(viewModel: PilotsListViewModel())
    }
}
