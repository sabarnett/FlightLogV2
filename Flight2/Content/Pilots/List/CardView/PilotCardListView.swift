//
// File: PilotCardListView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 12/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct PilotCardListView: View {
    
    @ObservedObject var vm: PilotsListViewModel
    
    init(viewModel: PilotsListViewModel) {
        self.vm = viewModel
    }
    
    var body: some View {
        GeometryReader { geoReader in
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(vm.pilotList, id: \.id) { pilot in
                            NavigationLink(destination: LazyLoadedView {
                                PilotDetailView(vm: PilotDetailViewModel(pilot: pilot))
                            },
                                           label: {
                                PilotCardView(pilot: pilot,
                                              cardWidth: geoReader.size.width - 70)
                                .frame(minHeight: 540)
                                    .padding(.horizontal, 4)
                            })
                            .tag(pilot.id)
                        }
                    }
                }
                .onChange(of: vm.selectedPilot) { newId in
                    value.scrollTo(vm.selectedPilot)
                }
                
            }
        }
        
        .id(vm.listRefresh)
        
        Spacer()
    }
}

struct PilotCardListView_Previews: PreviewProvider {
    static var previews: some View {
        PilotCardListView(viewModel: PilotsListViewModel())
    }
}
