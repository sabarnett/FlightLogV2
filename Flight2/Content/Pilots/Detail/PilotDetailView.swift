//
// File: PilotDetailView.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
             
import SwiftUI
import UtilityViews
import CoreData

struct PilotDetailView: View {
    
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var vm: PilotDetailViewModel
    @State var readonlyModal: Bool = false

    @State private var editPilot: Bool = false
    @State private var isPresentingDeleteConfirm: Bool = false
    
    init(pilotId: NSManagedObjectID) {
        vm = PilotDetailViewModel(pilotId: pilotId)
    }
    
    var body: some View {
        VStack {
            if vm.pilotId == nil {
                Text("Nothing selected")
            } else {
                Image(uiImage: vm.profilePicture)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(2)
                
                if vm.isDeleted {
                    HStack {
                        Spacer()
                        Text("This pilot has been deleted")
                            .padding(.vertical, 2)
                        Spacer()
                    }.background(Color(.systemRed))
                        .padding(.vertical, 2)
                }
                
                List {
                    Section {
                        DetailLine(key: "Name", value: "\(vm.firstName) \(vm.lastName)")
                        DetailLine(key: "CAA Reg", value: vm.caaRegistration)
                    } header: {
                        SectionTitle("Pilot")
                    }
                    
                    Section {
                        DetailLine(key: "Address", value: vm.address)
                        DetailLine(key: "Post Code", value: vm.postcode)
                        DetailLine(key: "Home Phone", value: vm.homePhone)
                        DetailLine(key: "Mobile Phone", value: vm.mobilePhone)
                        DetailLine(key: "Email", value: vm.email)
                    } header: {
                        SectionTitle("Contact Detals")
                    }
                }
                .listStyle(.grouped)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        HStack {
                            Button { editPilot = true } label: { Image(systemName: "square.and.pencil") }
                            Button { deletePilot() } label: { Image(systemName: vm.isDeleted ? "trash.slash" : "trash") }
                        }
                        .foregroundColor(.toolbarIcon)
                    }
                }
//                .sheet(isPresented: $editPilot, onDismiss: {
//                    vm.reloadData()
//                }) {
//                    PilotEdit(editViewModel: PilotEditViewModel(pilotID: vm.pilot.objectID))
//                }
                .confirmationDialog("Are you sure?",
                                    isPresented: $isPresentingDeleteConfirm) {
                    Button("Delete pilot?", role: .destructive) {
                        vm.deletePilot()
                    }
                } message: {
                    Text("You can undo this action.")
                }
                .interactiveDismissDisabled(true)
                .overlay(alignment: .topTrailing) {
                    if readonlyModal {
                        Button {
                            dismiss()
                        } label: {
                            XDismissButton()
                        }
                    }
                }
            }
        }
    }

    func deletePilot() {
        if vm.isDeleted {
            vm.undeletePilot()
            vm.reloadData()
        } else {
            isPresentingDeleteConfirm = true
        }
    }
}
