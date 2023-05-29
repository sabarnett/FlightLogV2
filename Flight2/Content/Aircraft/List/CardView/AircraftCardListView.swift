//
// File: AircraftCardListView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 16/12/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct AircraftCardListView: View {

    @ObservedObject var vm: AircraftListViewModel
    
    var body: some View {
        GeometryReader { geoReader in
            ScrollViewReader { value in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(vm.aircraftList, id: \.id) { aircraft in
                            NavigationLink(destination: LazyLoadedView {
                                AircraftDetailView(vm: AircraftDetailViewModel(aircraft: aircraft))
                            },
                                           label: {
                                AircraftCardView(aircraft: aircraft,
                                                 cardWidth: geoReader.size.width - 70)
                                    .frame(minHeight: 540)
                                    .padding(.horizontal, 4)
                            })
                            .tag(aircraft.id)
                        }
                    }
                }
                .onChange(of: vm.selectedAircraft) { newId in
                    value.scrollTo(vm.selectedAircraft)
                }
            }
        }
        
        .id(vm.listRefresh)
        
        Spacer()
    }
}

struct AircraftCardListView_Previews: PreviewProvider {
    static var previews: some View {
        AircraftCardListView(vm: AircraftListViewModel())
    }
}
