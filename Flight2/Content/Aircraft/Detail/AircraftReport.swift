//
// File: AircraftReport.swift
// Package: Flight2
// Created by: Steven Barnett on 07/07/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import PDFTools

class AircraftReport {
    
    func generateReport(for aircraft: Aircraft, withStats stats: StatisticsSummary) -> Data? {
        
        let generator = PDFGenerator(creator: "FlightLogV2",
                                     author: "Aircraft Report",
                                     title: "Pilot Report For \(aircraft.viewName)")
        
        generator.setPageSize(.A4)
        generator.setMargins(vertical: 60, horizontal: 50)
        
        headerPage(generator: generator, aircraft: aircraft)
        purchaseInfo(generator: generator, aircraft: aircraft)
        notes(generator: generator, aircraft: aircraft)
        statistics(generator: generator, stats: stats)
        maintenanceLog(generator: generator, aircraft: aircraft)
        
        return generator.render()
    }
    
    func headerPage(generator: PDFGenerator, aircraft: Aircraft) {
        
        let imageHeight = aircraft.viewAircraftImage.size.height
        let imageWidth = aircraft.viewAircraftImage.size.width
        
        // I want the image to fit height of 200
        let imageRenderWidth = imageWidth * (200 / imageHeight)
        
        generator.document.add(PDFSetCursor(newCursor: 80))
        generator.document.add(PDFBox(height: 40))
        generator.document.add(PDFParagraph(style: .title, text: aircraft.viewName))
        generator.document.add(PDFParagraph(style: .subtitle, text: aircraft.viewModel))
        generator.document.add(PDFParagraph(style: .subtitle, text: aircraft.viewSerialNumber))
        generator.document.add(PDFImage(image: aircraft.viewAircraftImage, size: CGSize(width: imageRenderWidth, height: 200)))
        generator.document.add(PDFSpacer(gap: 30))
        
        if !aircraft.viewdetails.isEmpty {
            generator.document.add(PDFParagraph(style: .heading1, text: "Description"))
            generator.document.add(PDFParagraph(style: .normal, text: aircraft.viewdetails))
        }
        
        generator.document.add(PDFNewPage())
    }
    
    func purchaseInfo(generator: PDFGenerator, aircraft: Aircraft) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Purchase Info"))
        
        generator.document.add(PDFLabelledText(label: "From", content: aircraft.viewPurchasedFrom, labelWidth: 90))
        generator.document.add(PDFLabelledText(label: "Date", content: aircraft.formattedPurchaseDate, labelWidth: 90))
        generator.document.add(PDFLabelledText(label: "New?", content: aircraft.viewNewAtPurchase, labelWidth: 90))
        
        generator.document.add(PDFSpacer(gap: 20))
    }
    
    func notes(generator: PDFGenerator, aircraft: Aircraft) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Notes"))
        
        generator.document.add(PDFParagraph(style: .normal, text: aircraft.viewNotes))
        
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
        
        generator.document.add(PDFSpacer(gap: 20))
    }
    
    func maintenanceLog(generator: PDFGenerator, aircraft: Aircraft) {
        generator.document.add(PDFParagraph(style: .heading2, text: "Maintenance Log"))

        if aircraft.maintenance?.count == 0 {
            generator.document.add(PDFParagraph(style: .normal, text: "No maintenance logged"))
            return
        }
        
        for item in aircraft.maintenanceItems {
            generator.document.add(PDFLabelledText(label: item.viewDate,
                                                   content: "\(item.viewTitle)\n\(item.viewAction)"))
        }
    }
}
