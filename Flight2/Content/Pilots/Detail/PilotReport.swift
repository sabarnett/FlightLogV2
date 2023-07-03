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

        generator.document.add(PDFSetCursor(newCursor: 130))
        generator.document.add(PDFBox(height: 40))
        generator.document.add(PDFParagraph(style: .title, text: pilot.displayName))
        generator.document.add(PDFParagraph(style: .subtitle, text: pilot.viewCAARegistration))
        generator.document.add(PDFImage(image: pilot.viewProfileImage))
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
        
        generator.document.add(PDFParagraph(style: .normal, text: "Address\t\(pilot.viewAddress)"))
        generator.document.add(PDFParagraph(style: .normal, text: "Postcode\t\(pilot.viewPostCode)"))
        generator.document.add(PDFParagraph(style: .normal, text: "Phone (Home)\t\(pilot.viewAlternatePhone)"))
        generator.document.add(PDFParagraph(style: .normal, text: "Phone (mobile)\t\(pilot.viewMobilePhone)"))
        generator.document.add(PDFParagraph(style: .normal, text: "Email\t\(pilot.viewEmailAddress)"))
    }
    
    func statistics(generator: PDFGenerator, stats: StatisticsSummary) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Flight Statistics"))
        
        generator.document.add(PDFParagraph(style: .normal, text: "Number of flights: \(stats.flightCount)"))
        generator.document.add(PDFParagraph(style: .normal, text: "Total flying time: \(stats.flightDuration) minutes"))

        generator.document.add(PDFParagraph(style: .heading4, text: "Flight Details"))
        for detail in stats.detail {
            generator.document.add(PDFParagraph(style: .normal, text: "\(detail.title) has been flown \(detail.count) times for \(detail.formattedFlightDuration) minutes in total."))
        }
    }
}
