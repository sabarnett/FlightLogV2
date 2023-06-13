//
// File: MessageBoxView.swift
// Package: Flight2
// Created by: Steven Barnett on 13/06/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct MessageBoxView: View {
    
    var message: MessageItem
    var onButtonPress: (MessageResponse) -> Void
    @State var isAnimating: Bool = false
        
    var body: some View {
        ZStack {
            VStack {
                titleText()
                
                messageBodyText()
                
                // If we have a dismiss button caption, then we want to show a single
                // button. If there is no caption, it is assumed that we want to display
                // two buttons. The colour of the buttons is set when they are defined.
                if message.dismissButton.caption.isEmpty {
                    doubleButton()
                } else {
                    singleButton()
                }
                
            }.padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.black)
                        .clipped()
                        .shadow(color: .white, radius: 2, x: 0, y: 0)
                )
            
        }
        .opacity(isAnimating ? 1 : 0)
        .frame(maxWidth: 380)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                isAnimating = true
            }
        }
        .onDisappear {
            isAnimating = false
        }
    }

    fileprivate func titleText() -> some View {
        return VStack {
            Text(message.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primaryText)
            Divider()
        }
    }
    
    fileprivate func messageBodyText() -> some View {
        return VStack {
            Text(message.message).font(.subheadline).padding(.vertical, 20)
            Divider()
        }
    }
    
    fileprivate func doubleButton() -> some View {
        return HStack(alignment: .center) {
            Spacer()
            Button(action: {
                onButtonPress(.primary)
            }, label: {
                APPButtonText(caption: message.primaryButton.caption,
                              buttonWidth: 120,
                              buttonHeight: 35,
                              backgroundColor: message.primaryButton.color,
                              foregroundColor: .primary)
            })
            Spacer()
            Divider()
            Spacer()
            Button(action: {
                onButtonPress(.secondary)
            }, label: {
                APPButtonText(caption: message.secondaryButton.caption,
                              buttonWidth: 120,
                              buttonHeight: 35,
                              backgroundColor: message.secondaryButton.color,
                              foregroundColor: .primary)
            })
            Spacer()
        }.frame(maxHeight: 50)
    }
    
    fileprivate func singleButton() -> some View {
        return Button(action: {
            onButtonPress(.dismiss)
        }, label: {
            APPButtonText(caption: message.dismissButton.caption,
                          buttonWidth: 180,
                          buttonHeight: 35,
                          backgroundColor: message.dismissButton.color)
        })
    }
}
