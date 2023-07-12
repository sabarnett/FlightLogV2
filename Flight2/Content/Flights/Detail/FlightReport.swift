//
// File: FlightReport.swift
// Package: Flight2
// Created by: Steven Barnett on 12/07/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import PDFTools

class FlightReport {
    
    func generateReport(for flight: Flight) -> Data? {
        
        let generator = PDFGenerator(creator: "FlightLogV2",
                                     author: "Flight Report",
                                     title: "Flight Report For \(flight.viewTitle)")
        
        generator.setPageSize(.A4)
        generator.setMargins(vertical: 80, horizontal: 50)
        
        headerPage(generator: generator, flight: flight)
        participants(generator: generator, flight: flight)
        location(generator: generator, flight: flight)
        preflightChecks(generator: generator, flight: flight)
        flightDetails(generator: generator, flight: flight)
        flightReview(generator: generator, flight: flight)
        notes(generator: generator, flight: flight)

        return generator.render()
    }
    
    func headerPage(generator: PDFGenerator, flight: Flight) {
        
        // Available space, less 30 for the gap. This defines the image space available
        let availableSpace = generator.pageLayout.pageRect.width - generator.pageLayout.margins - 30
        let desiredWidth = min(availableSpace / 2, 220)

        // Set the pilot image size such that it fits in the desired width.
        let pilotImageHeight = flight.viewPilot.viewProfileImage.size.height
        let pilotImageWidth = flight.viewPilot.viewProfileImage.size.width
        let pilotImageRenderHeight = pilotImageHeight * (desiredWidth / pilotImageWidth)
        let pilotImageLeft = ((availableSpace / 2) - desiredWidth) / 2 + generator.pageLayout.leftMargin
        
        let aircraftImageHeight = flight.viewAircraft.viewAircraftImage.size.height
        let aircraftImageWidth = flight.viewAircraft.viewAircraftImage.size.width
        let aircraftImageRenderHeight = aircraftImageHeight * (desiredWidth / aircraftImageWidth)
        
        let middleOfPage = (generator.pageLayout.pageRect.width) / 2
        let leadingGap = ((middleOfPage - generator.pageLayout.rightMargin) - desiredWidth) / 2
        let aircraftImageLeft = middleOfPage + leadingGap

        generator.document.add(PDFSetCursor(newCursor: 80))
        generator.document.add(PDFBox(height: 40))
        generator.document.add(PDFParagraph(style: .title, text: flight.viewTitle))
        generator.document.add(PDFParagraph(style: .subtitle, text: flight.viewTakeoffDate))
        generator.document.add(PDFImage(image: flight.viewPilot.viewProfileImage,
                                        at: CGPoint(x: pilotImageLeft, y: 250),
                                        size: CGSize(width: desiredWidth, height: pilotImageRenderHeight)))
        generator.document.add(PDFImage(image: flight.viewAircraft.viewAircraftImage,
                                        at: CGPoint(x: aircraftImageLeft, y: 250),
                                        size: CGSize(width: desiredWidth, height: aircraftImageRenderHeight)))
        let gap = max(pilotImageRenderHeight, aircraftImageHeight)
        generator.document.add(PDFSpacer(gap: gap))

        if !flight.viewActivity.isEmpty {
            generator.document.add(PDFParagraph(style: .heading1, text: "Flight Activity"))
            generator.document.add(PDFParagraph(style: .normal, text: flight.viewActivity))
        }

        generator.document.add(PDFNewPage())
    }
    
    func participants(generator: PDFGenerator, flight: Flight) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Participants"))
        generator.document.add(PDFParagraph(style: .heading4, text: "Pilot"))
        
        generator.document.add(PDFLabelledText(label: "Name", content: flight.viewPilot.viewDisplayName))
        generator.document.add(PDFLabelledText(label: "CAA Reg.", content: flight.viewPilot.viewCAARegistration))
        generator.document.add(PDFLabelledText(label: "Phone", content: flight.viewPilot.viewMobilePhone))
        generator.document.add(PDFLabelledText(label: "Email", content: flight.viewPilot.viewEmailAddress))
        if !flight.viewPilot.viewBiography.isEmpty {
            generator.document.add(PDFParagraph(style: .normal, text: flight.viewPilot.viewBiography))
        }

        generator.document.add(PDFParagraph(style: .heading4, text: "Aircraft"))
        generator.document.add(PDFLabelledText(label: "Name", content: flight.viewAircraft.viewName))
        generator.document.add(PDFLabelledText(label: "Model", content: flight.viewAircraft.viewModel))
        generator.document.add(PDFLabelledText(label: "Manufacturer", content: flight.viewAircraft.viewManufacturer))
        generator.document.add(PDFLabelledText(label: "S/N", content: flight.viewAircraft.viewSerialNumber))
        if !flight.viewAircraft.viewdetails.isEmpty {
            generator.document.add(PDFParagraph(style: .normal, text: flight.viewAircraft.viewdetails))
        }

        generator.document.add(PDFSpacer(gap: 20))
    }
    
    func location(generator: PDFGenerator, flight: Flight) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Location"))
        generator.document.add(PDFLabelledText(label: "Location", content: flight.viewLocation))
        generator.document.add(PDFLabelledText(label: "Weather", content: flight.viewWeatherConditions))
        generator.document.add(PDFLabelledText(label: "Site", content: flight.viewSiteConditions))
        generator.document.add(PDFSpacer(gap: 20))
    }

    func preflightChecks(generator: PDFGenerator, flight: Flight) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Pre-Flight Checks"))
        generator.document.add(PDFLabelledText(label: "Checks Performed",
                                               content: yesNo(flight.viewPreflightChecksPerformed),
                                               labelWidth: 110))
        generator.document.add(PDFLabelledText(label: "Issues Resolved",
                                               content: yesNo(flight.viewPreflightIssuesResolved),
                                               labelWidth: 100))
        if let issues = flight.preflightIssues {
            for case let issue as FlightIssue in issues {
                generator.document.add(PDFParagraph(style: .heading4, text: issue.viewTitle))
                generator.document.add(PDFParagraph(style: .normal, text: issue.viewNotes))
                generator.document.add(PDFParagraph(style: .footnote,
                                                    text: "Issue was: " + (issue.resolved ? "resolved" : " not resolved")))
            }
        } else {
            generator.document.add(PDFParagraph(style: .normal, text: "No issues logged"))
        }

        generator.document.add(PDFSpacer(gap: 20))
    }

    func flightDetails(generator: PDFGenerator, flight: Flight) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Flight Details"))
        generator.document.add(PDFLabelledText(label: "Take off", content: flight.viewTakeoffDate))
        generator.document.add(PDFLabelledText(label: "Landing", content: flight.viewLandingDate))
        generator.document.add(PDFLabelledText(label: "Duration",
                                               content: flightDuration(takeOff: flight.takeoff, landing: flight.landing)))
        
        if let details = flight.details, !details.isEmpty {
            generator.document.add(PDFParagraph(style: .heading3, text: "Flight Review"))
            generator.document.add(PDFParagraph(style: .normal, text: details))
        }
        
        generator.document.add(PDFParagraph(style: .heading3, text: "Flight Issues"))
        if let issues = flight.flightIssues {
            for case let issue as FlightIssue in issues {
                generator.document.add(PDFParagraph(style: .heading4, text: issue.viewTitle))
                generator.document.add(PDFParagraph(style: .normal, text: issue.viewNotes))
                generator.document.add(PDFParagraph(style: .footnote,
                                                    text: "Issue was: " + (issue.resolved ? "resolved" : " not resolved")))
            }
        } else {
            generator.document.add(PDFParagraph(style: .normal, text: "No flight issues logged"))
        }
        
        generator.document.add(PDFSpacer(gap: 20))
    }
    
    func flightReview(generator: PDFGenerator, flight: Flight) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Flight Review"))

        generator.document.add(PDFParagraph(style: .normal, text: flight.viewNotes))

        generator.document.add(PDFSpacer(gap: 20))

    }

    func notes(generator: PDFGenerator, flight: Flight) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Notes"))
        generator.document.add(PDFParagraph(style: .normal, text: flight.viewNotes))
        generator.document.add(PDFSpacer(gap: 20))
    }

    private func yesNo(_ value: Bool) -> String {
        value ? "Yes" : "No"
    }
    
    private func flightDuration(takeOff: Date?, landing: Date?) -> String {
        guard let takeOffDate = takeOff,
                let landingDate = landing else {
            return "N/A"
        }
        let duration = landingDate - takeOffDate
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        
        return formatter.string(from: duration) ?? "N/A"
    }
}
