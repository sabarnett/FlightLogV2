//
// File: PilotReport.swift
// Package: Flight2
// Created by: Steven Barnett on 03/07/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import PDFTools

class PilotReport {
    
    func generateReport(for pilot: Pilot, withStats stats: StatisticsSummary) -> Data? {

        let generator = PDFGenerator(creator: "FlightLogV2",
                                     author: "Pilot Report",
                                     title: "Pilot Report For \(pilot.displayName)")

        headerPage(generator: generator, pilot: pilot)
        contactDetails(generator: generator, pilot: pilot)
        statistics(generator: generator, stats: stats)

        return generator.render()
    }
    
    func headerPage(generator: PDFGenerator, pilot: Pilot) {

        let imageHeight = pilot.viewProfileImage.size.height
        let imageWidth = pilot.viewProfileImage.size.width
        
        // I want the image to fit height of 200
        let imageRenderWidth = imageWidth * (200 / imageHeight)
        
        generator.document.add(PDFSetCursor(newCursor: 130))
        generator.document.add(PDFBox(height: 40))
        generator.document.add(PDFParagraph(style: .title, text: pilot.displayName))
        generator.document.add(PDFParagraph(style: .subtitle, text: pilot.viewCAARegistration))
        generator.document.add(PDFImage(image: pilot.viewProfileImage, size: CGSize(width: imageRenderWidth, height: 200)))
        generator.document.add(PDFSpacer(gap: 10))
        generator.document.add(PDFLine(lineWidth: 2))
        generator.document.add(PDFSpacer(gap: 10))

        if !pilot.viewBiography.isEmpty {
            generator.document.add(PDFParagraph(style: .heading1, text: "Pilot Biography"))
            generator.document.add(PDFParagraph(style: .normal, text: pilot.viewBiography))
        }
        
        generator.document.add(PDFNewPage())
    }
    
    func contactDetails(generator: PDFGenerator, pilot: Pilot) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Contact Details"))
        
        generator.document.add(PDFLabelledText(label: "Address", content: pilot.viewAddress, labelWidth: 110))
        generator.document.add(PDFLabelledText(label: "Post code", content: pilot.viewPostCode, labelWidth: 110))
        generator.document.add(PDFLabelledText(label: "Phone (Home)", content: pilot.viewAlternatePhone, labelWidth: 110))
        generator.document.add(PDFLabelledText(label: "Phone(Mobile)", content: pilot.viewMobilePhone, labelWidth: 110))
        generator.document.add(PDFLabelledText(label: "Email", content: pilot.viewEmailAddress, labelWidth: 110))

        generator.document.add(PDFSpacer(gap: 20))
    }
    
    func statistics(generator: PDFGenerator, stats: StatisticsSummary) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Flight Statistics"))

        generator.document.add(PDFLabelledText(label: "Number of flights",
                                               content: "\(stats.flightCount)",
                                               labelWidth: 110))
        generator.document.add(PDFLabelledText(label: "Total flying time",
                                               content: "\(stats.flightDuration) minutes",
                                               labelWidth: 110))
        
        generator.document.add(PDFSpacer(gap: 20))

        generator.document.add(PDFParagraph(style: .heading4, text: "Flight Details"))
        for detail in stats.detail {
            let statsLine = "Number of flights: \(detail.count)\n" +
            "Flying time: \(detail.formattedFlightDuration) minutes."
            
            generator.document.add(PDFLabelledText(label: detail.title,
                                                   content: statsLine,
                                                   labelWidth: 110))
        }
    }
}
