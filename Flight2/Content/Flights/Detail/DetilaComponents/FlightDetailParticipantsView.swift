//
// File: FlightDetailParticipantsView.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/02/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//


import SwiftUI

struct FlightDetailParticipantsView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var vm: FlightDetailViewModel
    @State var showPilotDetail: Bool = false
    @State var showAircraftdetail: Bool = false
    
    var body: some View {
        Section("Participants") {
            if horizontalSizeClass == .regular {
                HStack {
                    Spacer()
                    ImageAndText(image: vm.profileImage,
                                 title: "\(vm.pilot.firstName ?? "") \(vm.pilot.lastName ?? "")",
                                 subTitle: vm.pilot.caaRegistration)
                    .onTapGesture {
                        showPilotDetail.toggle()
                    }
                    
                    Spacer()
                    ImageAndText(image: vm.aircraftImage,
                                 title: vm.aircraft.name,
                                 subTitle: vm.aircraft.serialNumber)
                    .onTapGesture {
                        showAircraftdetail.toggle()
                    }
                    
                    Spacer()
                }
                
            } else {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        ImageAndText(image: vm.profileImage,
                                     title: "\(vm.pilot.firstName ?? "") \(vm.pilot.lastName ?? "")",
                                     subTitle: vm.pilot.caaRegistration)
                        .onTapGesture {
                            showPilotDetail.toggle()
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        ImageAndText(image: vm.aircraftImage, title: vm.aircraft.name, subTitle: vm.aircraft.serialNumber)
                            .onTapGesture {
                                showAircraftdetail.toggle()
                            }
                        Spacer()
                    }
                }
                
            }
        }
        .sheet(isPresented: $showPilotDetail) {
            PilotDetailView(vm: PilotDetailViewModel(pilot: vm.pilot),
                            readonlyModal: true)
        }
        .sheet(isPresented: $showAircraftdetail) {
            AircraftDetailView(vm: AircraftDetailViewModel(aircraft: vm.aircraft),
                               readonlyModal: true)

        }
    }
}

struct ImageAndText: View {
    
    var image: UIImage
    var title: String?
    var subTitle: String?
    
    var body : some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)).shadow(color: .secondary, radius: 3, x: 2, y:2)
                .frame(width: 200, height: 200)
                .padding(4)
            
            Text(title ?? "").font(.title3)
            Text(subTitle ?? "").font(.caption)
        }
    }
}
