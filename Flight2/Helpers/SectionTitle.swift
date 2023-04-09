//
// File: SectionTitle.swift
// Package: Flight2
// Created by: Steven Barnett on 29/03/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct SectionTitle: View {
    
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .bold()
            .font(.title3)
            .foregroundColor(.heading)
            //.padding(.vertical)
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle("Section Title")
    }
}
