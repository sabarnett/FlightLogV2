//
// File: MessageBoxViewModifier.swift
// Package: Flight2
// Created by: Steven Barnett on 13/06/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct MessageBoxViewModifier: ViewModifier {
    
    @Binding var message: MessageItem?
    var buttonPressed: ((MessageResponse) -> Void)?
    
    init(message: Binding<MessageItem?>, onButtonPress: ((MessageResponse) -> Void)? = nil) {
        self._message = message
        self.buttonPressed = onButtonPress
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .onChange(of: message, perform: { msg in
                    if msg != nil {
                        // We have been passed a message to display. Disable animations while the
                        // message is displayed so the fullScreenCover is not animated.
                        UIView.setAnimationsEnabled(false)
                    }
                })
                .fullScreenCover(item: $message) {
                    messageItem in
                    
                    ZStack {
                        MessageBoxView(message: messageItem) {
                            response in
                            
                            message = nil
                            if let buttonPressed = buttonPressed {
                                buttonPressed(response)
                            }
                        }.padding(.horizontal, 10)
                    }
                    .background(FullScreenCoverBackgroundRemovalView())
                    .onDisappear {
                        // The message has been dismissed, so we re-enable animations.
                        UIView.setAnimationsEnabled(true)
                    }
                }
        }
    }
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    
    private class BackgroundRemovalView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}

extension View {
    func messageBox(message: Binding<MessageItem?>, onButtonPress: ((MessageResponse) -> Void)? = nil) -> some View {
        self.modifier(MessageBoxViewModifier(message: message, onButtonPress: onButtonPress))
    }
}
