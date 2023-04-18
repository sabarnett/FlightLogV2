//
// File: PlaceHolderView.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 12/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PlaceHolderView: View {
    
    let image: String
    let prompt: String
    
    var body: some View {
        VStack {
            Spacer()
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .opacity(0.3)
                .padding(.bottom, 40)
            Text(prompt)
                .font(.title3)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct PlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHolderView(
            image: "flights-placeholder",
            prompt: "Select Add to add a flight"
        )
    }
}
