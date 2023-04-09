//
// File: DetailLine.swift
// Package: Flight2
// Created by: Steven Barnett on 05/04/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct DetailLine: View {
    
    var key: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(key)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .frame(minWidth: 20, idealWidth: 30, maxWidth: 90, alignment: .leading)
            }
            VStack(alignment: .leading) {
                Text(value)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
            
    }
}

struct DetailLine_Previews: PreviewProvider {
    static var previews: some View {
        DetailLine(key: "Name", value: "Value")
    }
}
