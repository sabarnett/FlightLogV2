//
// File: PilotDetailView.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
             
import SwiftUI
import UtilityViews
import PDFTools
import CoreData

struct PilotDetailView: View {
    
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var vm: PilotDetailViewModel
    @State var readonlyModal: Bool = false

    @State private var editPilot: Bool = false
    @State private var isPresentingDeleteConfirm: Bool = false
    @State private var showReport: Bool = false
    
    var body: some View {
        VStack {
            if vm.pilotId == nil {
                NothingSelectedView()
            } else {
                VStack {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        HStack(alignment: .top) {
                            Image(uiImage: vm.pilot.viewProfileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .padding(2)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(vm.pilot.displayName).font(.title).foregroundColor(Color.heading)
                                Text(vm.pilot.viewCAARegistration).font(.title2)
                                Text(vm.pilot.viewMobilePhone).font(.title2)
                            }.foregroundColor(.primaryText)
                            Spacer()
                        }.frame(height: 210)
                            .padding(20)
                    } else {
                        Image(uiImage: vm.pilot.viewProfileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .padding(2)
                    }
                    
                    if vm.pilot.pilotDeleted {
                        HStack {
                            Spacer()
                            Text("This pilot has been deleted")
                                .padding(.vertical, 2)
                            Spacer()
                        }.background(Color(.systemRed))
                            .padding(.vertical, 2)
                    }
                    
                    List {
                        if UIDevice.current.userInterfaceIdiom != .pad {
                            Section(content: {
                                DetailLine(key: "Name", value: "\(vm.pilot.viewFirstName) \(vm.pilot.viewLastName)")
                                DetailLine(key: "CAA Reg", value: vm.pilot.viewCAARegistration)
                            }, header: {
                                SectionTitle("Pilot")
                            }).foregroundColor(.primaryText)
                        }
                        
                        Section(content: {
                            DetailLine(key: "Address", value: vm.pilot.viewAddress).foregroundColor(.primaryText)
                            DetailLine(key: "Post Code", value: vm.pilot.viewPostCode)
                            DetailLine(key: "Home Phone", value: vm.pilot.viewAlternatePhone)
                            DetailLine(key: "Mobile Phone", value: vm.pilot.viewMobilePhone)
                            DetailLine(key: "Email", value: vm.pilot.viewEmailAddress)
                        }, header: {
                            SectionTitle("Contact Detals")
                        }).foregroundColor(.primaryText)
                        
                        Section(content: {
                            DetailLine(key: "Biography", value: vm.pilot.viewBiography).foregroundColor(.primaryText)
                        }, header: {
                            SectionTitle("About Me")
                        }).foregroundColor(.primaryText)
                        
                        Section(content: {
                            StatisticsView(statistics: vm.flightStats)
                        }, header: {
                            SectionTitle("Flight Statistics")
                        })
                    }
                    .listStyle(.grouped)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        if !readonlyModal {
                            ToolbarItemGroup(placement: .primaryAction) {
                                HStack {
                                    if !vm.pilot.pilotDeleted {
                                        Button(action: { editPilot = true
                                        }, label: { Image(systemName: "square.and.pencil") })
                                    }
                                    
                                    Button(action: { deletePilot()
                                    }, label: { Image(systemName: vm.pilot.pilotDeleted ? "trash.slash" : "trash") })
                                    .confirmationDialog("Are you sure?",
                                                        isPresented: $isPresentingDeleteConfirm,
                                                        actions: {
                                        Button("Delete pilot?", role: .destructive) {
                                            vm.deletePilot()
                                        }
                                    }, message: {
                                        Text("You can undo this action.")
                                    })
                                    
                                    Button(action: {createReport() },
                                           label: { Image(systemName: "doc.richtext")})

                                }
                                .foregroundColor(.toolbarIcon)
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showReport) {
                    ShowReport(reportTitle: "Pilot Report", pdfData: vm.pdfReport)
                }
                .fullScreenCover(isPresented: $editPilot, onDismiss: {
                    vm.reloadData()
                }, content: {
                    if let pilotId = vm.pilotId {
                        PilotEdit(editViewModel: PilotEditViewModel(pilotID: pilotId))
                    }
                })
                .interactiveDismissDisabled(true)
                .overlay(alignment: .topTrailing) {
                    if readonlyModal {
                        Button(action: {
                            dismiss()
                        }, label: {
                            XDismissButton()
                        })
                    }
                }.padding(.horizontal)
            }
        }
    }

    func deletePilot() {
        if vm.pilot.pilotDeleted {
            vm.undeletePilot()
            vm.reloadData()
        } else {
            isPresentingDeleteConfirm = true
        }
    }
    
    func createReport() {
        // TODO: Generate the report
        showReport = true
    }
}
