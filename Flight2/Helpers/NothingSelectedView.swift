//
// File: NothingSelectedView.swift
// Package: Flight2
// Created by: Steven Barnett on 11/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct NothingSelectedView: View {
    
    @State var prompt: String = ""
    
    var body: some View {
        VStack {
            Image("LaunchImage")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 180)
            Text("Nothing Selected").font(.body).padding(.vertical, 15)
            Text(prompt).font(.body)
        }
    }
}

struct NothingSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        NothingSelectedView()
    }
}
