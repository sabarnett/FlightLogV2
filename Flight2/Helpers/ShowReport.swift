//
// File: ShowReport.swift
// Package: Flight2
// Created by: Steven Barnett on 02/07/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//
        
import PDFTools
import UtilityViews
import SwiftUI

struct ShowReport: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var reportTitle: String
    @State var pdfData: Data?

    var body: some View {
        VStack(alignment: .leading) {
            SectionTitle(reportTitle).padding(.vertical, 15)
            PDFTools.PDFViewer(pdfData: pdfData)
        }
        .interactiveDismissDisabled(true)
        .overlay(alignment: .topTrailing) {
            Button(action: {
                dismiss()
            }, label: {
                XDismissButton()
            })
        }.padding(.horizontal)
    }
}

struct ShowReport_Previews: PreviewProvider {
    static var previews: some View {
        ShowReport(reportTitle: "Test Title")
    }
}
