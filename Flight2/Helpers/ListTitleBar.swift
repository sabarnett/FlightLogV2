//
// File: DetilaToolbar.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct AdditionalToolbarButton: Identifiable {
    let id: UUID = UUID()
    var label: String?
    var image: Image?
    var action: () -> Void
}

struct ListTitleBar: View {
    
    @State private var showSettings: Bool = false
    @State private var showAbout: Bool = false
    @State var title: String
    @State var iconName: String
    var additionalButtons: [AdditionalToolbarButton] = []
    
    var body: some View {
        VStack {
            Text("")
            HStack{
                Image(systemName: iconName)
                Text(title)
                Spacer()
            }.font(.title2)
                .padding()
                .foregroundColor(.heading)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                HStack(spacing: 6) {
                    
                    Button(action: {
                        showSettings.toggle()
                    }, label: {
                        Image(systemName: "gear")
                    })
                    
                    Button(action: {
                        showAbout.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                }
                .foregroundColor(.toolbarIcon)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack(spacing: 6) {
                    // Allow the user to put additional buttons after the system buttons.
                    ForEach(additionalButtons) { button in
                        Button(action: {
                            button.action()
                        }, label: {
                            if let label = button.label {
                                Text(label)
                            } else if let image = button.image {
                                image
                            } else {
                                Text("?")
                            }
                        })
                    }
                }
                .foregroundColor(.toolbarIcon)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showAbout) {
            InfoView()
        }
    }
}

