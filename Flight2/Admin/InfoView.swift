//
// File: InfoView.swift
// Package: Flight2
// Created by: Steven Barnett on 27/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews

struct InfoView: View {
    
    let appName: String = Bundle.main.displayName
    let appOrg: String = "Steven Barnett"
    let appLogo: String = "LaunchImage"
    let appWebSite: String = "http://www.sabarnett.co.uk"
    let appEmail: String = "mac@sabarnett.co.uk"
    let appCopyright: String = "Copyright © 2022 Steven Barnett. All rights reserved."
    let appVersion: String = Bundle.main.releaseAndBuildVersionNumberPretty
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    Section(header: SectionTitle("About the App")) {
                        KeyValueView(key: "Name", value: appName)
                        KeyValueView(key: "Version", value: appVersion)
                        KeyValueView(key: "Author", value: appOrg)
                    }
                    Section(header: SectionTitle("Support")) {
                        KeyValueView(key: "Web", value: appWebSite)
                        KeyValueView(key: "Email", value: appEmail)
                    }
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            Image(appLogo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150, alignment: .center)
                                .opacity(0.6)
                            Text(appCopyright)
                                .font(.callout)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button { dismiss() }
                label: {
                    Image(systemName: "x.circle.fill")
                        .font(Font.body.weight(.bold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .scaleEffect(1.5)
                    }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfoView()
                .preferredColorScheme(.dark)
        }
    }
}


