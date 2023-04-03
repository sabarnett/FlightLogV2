//
// File: ImagePicker.swift
// Package: RCFlightLog
// Created by: Steven Barnett on 19/11/2022
// 
// Copyright © 2022 Steven Barnett. All rights reserved.
//

import SwiftUI
import UtilityViews
import Mantis

struct ImagePickerView: View {
    
    @Binding var image: UIImage
    @State private var showCameraSelection: Bool = false
    @State private var showPhotoSelection: Bool = false
    
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
    var placeholderImage: String
    var displayedImage: UIImage {
        image.size.width > 0
            ? image
            : UIImage(named: placeholderImage) ?? UIImage()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Image(uiImage: displayedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 280, height: 280)
            
            VStack {
                Button(action: { },label: {
                    Image(systemName: "camera")
                        .scaleEffect(1.4)
                        .foregroundColor(.primary)
                        .padding(10)
                        .padding(.top, 10)
                })
                .onTapGesture {
                    showCameraSelection = true
                }
                
                Button(action: { },label: {
                    Image(systemName: "photo")
                        .scaleEffect(1.4)
                        .foregroundColor(.primary)
                        .padding(10)
                })
                .onTapGesture {
                    showPhotoSelection = true
                }
                
                Button(action: { },label: {
                    Image(systemName: "trash")
                        .scaleEffect(1.4)
                        .foregroundColor(.primary)
                        .padding(10)
                })
                .onTapGesture {
                    image = UIImage()
                }
                
                Button(action: { },label: {
                    Image(systemName: "pencil")
                        .scaleEffect(1.4)
                        .foregroundColor(.primary)
                        .padding(10)
                        .padding(.bottom, 10)
                })
                .onTapGesture {
                    showingCropper = true
                }

            }
            .frame(minWidth: 40, idealWidth: 40, maxWidth: 50)
            .background(.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Spacer()
        }
        .frame(width: 300, height: 300)
        .sheet(isPresented: $showPhotoSelection) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showCameraSelection) {
            ImagePicker(selectedImage: self.$image, sourceType: .camera)
        }
        .sheet(isPresented: $showingCropper, content: {
            ImageCropper(image: $image,
                         cropShapeType: $cropShapeType,
                         presetFixedRatioType: $presetFixedRatioType)
                .ignoresSafeArea()
        })
    }
    
}

struct ImagePicker_Previews: PreviewProvider {    
    static var previews: some View {
        ImagePickerView(image: .constant(UIImage(named: "plane-placeholder")!), placeholderImage: "person-placeholder")
            .previewLayout(.sizeThatFits)
    }
}
