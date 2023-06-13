//
// File: Messages.swift
// Package: Flight2
// Created by: Steven Barnett on 13/06/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

enum MessageResponse {
    case primary
    case secondary
    case dismiss
}

struct MessageButton {
    let type: MessageResponse
    var caption: String
    var color: Color = Color(UIColor.systemBlue)
}

struct MessageItem: Identifiable, Equatable {
    
    static func == (lhs: MessageItem, rhs: MessageItem) -> Bool {
        lhs.id == rhs.id
    }
    
    init(title: String, message: String, dismissButton: String, dismissButtonColor: Color = Color(UIColor.systemBlue)) {
        self.title = title
        self.message = message
        self.dismissButton.caption = dismissButton
    }
    
    init(title: String, message: String, primaryButton: String, secondaryButton: String,
         primaryButtonColor: Color = Color(UIColor.systemRed), secondaryButtonColor: Color = Color(UIColor.systemBlue)) {
        self.title = title
        self.message = message
        
        self.primaryButton.caption = primaryButton
        self.primaryButton.color = primaryButtonColor
        
        self.secondaryButton.caption = secondaryButton
        self.secondaryButton.color = secondaryButtonColor
    }
    
    let id = UUID()
    var title: String
    var message: String
    var dismissButton: MessageButton = MessageButton(type: .dismiss, caption: "", color: Color(UIColor.systemBlue))
    var primaryButton: MessageButton = MessageButton(type: .primary, caption: "", color: Color(UIColor.systemRed))
    var secondaryButton: MessageButton = MessageButton(type: .secondary, caption: "", color: Color(UIColor.systemBlue))
}

struct MessageContext {

    static let flightLockConfirmPrompt = MessageItem(title: "Lock Flight?",
        message: "Please confirm that you want to lock this flight." +
                 "\n\nYou CANNOT undo this operation.",
        primaryButton: "Lock",
        secondaryButton: "Cancel"
    )
    
    static let flightIsLocked = MessageItem(title: "Flight Locked",
        message: "This flight has been locked. You can continue to edit notes, but nothing else.",
        dismissButton: "OK")

//    static let oldPasswordRequired = MessageItem(title: "Invalid Entry",
//                                                 message: "You must enter your current password.",
//                                                 dismissButton: "OK")
}
