//
// File: FlightsDetail.swift
// Package: RC Flight Log
// Created by: Steven Barnett on 24/01/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews
import UtilityClasses

struct FlightDetailView: View {
    
    @ObservedObject var vm: FlightDetailViewModel
    @State var editFlight: Bool = false
    @State private var confirmDelete: Bool = false
    @State private var confirmLock: Bool = false
    @State private var confirmLockAgain: MessageItem?
    @State private var flightLockMessage: MessageItem?
    
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
                        if vm.isLocked {
                            Button(action: { flightLockMessage = MessageContext.flightIsLocked },
                                   label: { Image(systemName: "lock.fill")
                                    .foregroundColor(Color(.systemRed))
                            })
                        } else {
                            Button(action: { lockFlight()},
                                   label: { Image(systemName: "lock.open.fill")})
                            .confirmationDialog("Are you sure?",
                                                isPresented: $confirmLock,
                                                actions: {
                                Button("Lock flight?", role: .destructive) {
                                    confirmLockAgain = MessageContext.flightLockConfirmPrompt
                                }
                            }, message: {
                                Text("This will lock the flight. After it is locked you will ONLY be able to edit notes. Everything else will be locked for change.\n\nThis action CANNOT be undone.")
                            })
                        }
                        Button(action: { editFlight = true },
                               label: { Image(systemName: "square.and.pencil") })
                        Button(action: { deleteFlight() },
                               label: { Image(systemName: vm.isDeleted ? "trash.slash" : "trash") })
                            .disabled(!vm.canDelete)
                            .confirmationDialog("Are you sure?",
                                                isPresented: $confirmDelete,
                                                actions: {
                                Button("Delete flight?", role: .destructive) {
                                    vm.deleteFlight()
                                }
                            }, message: {
                                Text("You can undo this action.")
                            })
                    }.foregroundColor(.toolbarIcon)
                }
            }
            .fullScreenCover(isPresented: $editFlight, onDismiss: {
                vm.reloadData()
            }, content: {
                FlightEdit(editViewModel: FlightEditViewModel(flightID: vm.flight.objectID))
            })
            .messageBox(message: $confirmLockAgain) {
                response in
                
                if response == .primary {
                    vm.lockFlight()
                }
            }
            .messageBox(message: $flightLockMessage)
        }
    }
    
    func deleteFlight() {
        if vm.isDeleted {
            vm.undeleteFlight()
            vm.reloadData()
        } else {
            confirmDelete = true
        }
    }
    
    func lockFlight() {
        confirmLock = true
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
