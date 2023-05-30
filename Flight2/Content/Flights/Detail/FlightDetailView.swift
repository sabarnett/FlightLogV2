//
// File: FlightsDetail.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct FlightDetailView: View {
    
    @ObservedObject var vm: FlightDetailViewModel
    @State var editFlight: Bool = false
    @State private var isPresentingDeleteConfirm: Bool = false
    
    var body: some View {
        if vm.flightId == nil {
            Text("Nothing Selected")
        } else {
            VStack(alignment: .leading) {
                Text(vm.title)
                    .font(.title)
                    .padding()
                    .foregroundColor(.heading)
                
                if vm.isDeleted {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Flight has been deleted")
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    .background(Color(.systemRed))
                }
                
                List {
                    FlightDetailActivityView(vm: vm)
                    FlightDetailParticipantsView(vm: vm)
                    FlightDetailLocationView(vm: vm)
                    FlightDetailPreflightView(vm: vm)
                    FlightDetailFlightView(vm: vm)
                    FlightDetailNotesView(vm: vm)
                }.id(vm.flightId)
                Spacer()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack {
                        Button(action: { editFlight = true },
                               label: { Image(systemName: "square.and.pencil") })
                        Button(action: { deleteFlight() },
                               label: { Image(systemName: vm.isDeleted ? "trash.slash" : "trash") })
                            .disabled(!vm.canDelete)
                    }.foregroundColor(.toolbarIcon)
                }
            }
            .fullScreenCover(isPresented: $editFlight, onDismiss: {
                vm.reloadData()
            }, content: {
                FlightEdit(editViewModel: FlightEditViewModel(flightID: vm.flight.objectID))
            })
            .confirmationDialog("Are you sure?",
                                isPresented: $isPresentingDeleteConfirm,
                                actions: {
                Button("Delete flight?", role: .destructive) {
                    vm.deleteFlight()
                }
            }, message: {
                Text("You can undo this action.")
            })
        }
    }
    
    func deleteFlight() {
        if vm.isDeleted {
            vm.undeleteFlight()
            vm.reloadData()
        } else {
            isPresentingDeleteConfirm = true
        }
    }
}

struct SectionSubtitle: View {
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title).font(.caption).opacity(0.6)
    }
}

struct FlightsDetail_Previews: PreviewProvider {
    static var previews: some View {
        FlightDetailView(vm: FlightDetailViewModel(flight: Flight()))
    }
}
