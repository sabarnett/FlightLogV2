//
// File: PilotEdit.swift
// Package: Flight2
// Created by: Steven Barnett on 06/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI
import UtilityViews

struct PilotEdit: View {
    
    @Environment(\.dismiss) private var dismiss

    @StateObject var editViewModel: PilotEditViewModel
    @State private var isEditingAddress: Bool = false
    
    var body: some View {
        VStack {
            List {
                Section(content: {
                    HStack {
                        Spacer()
                        ImagePickerView(image: $editViewModel.profilePicture,
                                        placeholderImage: "person-placeholder")
                        Spacer()
                    }
                    .padding()
                }, header: {
                    SectionTitle("Profile Image")
                })
                
                Section(content: {
                    FloatingTextView("First Name", text: $editViewModel.firstName)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                    FloatingTextView("Last Name", text: $editViewModel.lastName)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                    FloatingTextView("CAA Registration", text: $editViewModel.caaRegistration)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.characters)
                }, header: {
                    SectionTitle("Name")
                })
                
                Section(content: {
                    TextEdit(placeholder: "Address", text: $editViewModel.address)
                        .frame(minHeight: 100)
                    FloatingTextView("Post Code", text: $editViewModel.postCode)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.characters)
                    FloatingTextView("Home Phone", text: $editViewModel.homePhone)
                        .textContentType(.telephoneNumber)
                    FloatingTextView("Mobile Phone", text: $editViewModel.mobilePhone)
                    FloatingTextView("Email address", text: $editViewModel.email)
                        .autocorrectionDisabled(true)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }, header: {
                    SectionTitle("Contact")
                })
                
                Section(content: {
                    Text("Tell us something about yourself and your history")
                    TextEdit(placeholder: "Biography", text: $editViewModel.biography)
                        .frame(minHeight: 200)
                }, header: {
                    SectionTitle("Biography")
                })
                
                if editViewModel.hasErrors {
                    Section(content: {
                        Text(editViewModel.errorDigest)
                            .foregroundColor(Color(.systemRed))
                    }, header: {
                        SectionTitle("Errors")
                    })
                }
            }
            .listStyle(.grouped)
            
            Spacer()
            HStack {
                Button("Save") {
                    editViewModel.save()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemGreen))
                .disabled(!editViewModel.canSave())
                
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemRed))
            }.padding(.bottom, 8)
        }
        .interactiveDismissDisabled(true)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                dismiss()
            }, label: {
                XDismissButton()
            })
        }
    }
}

struct PilotEdit_Previews: PreviewProvider {
    static var previews: some View {
        PilotEdit(editViewModel: PilotEditViewModel(pilotID: nil))
    }
}
