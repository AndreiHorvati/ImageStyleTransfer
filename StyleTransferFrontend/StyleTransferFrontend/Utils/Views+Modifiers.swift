//
//  Views+Modifiers.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 11.04.2023.
//

import SwiftUI

struct PaintingFrame: ViewModifier {
    let blackColorSize: CGFloat
    let imageSize: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            Color.black
                .frame(width: blackColorSize, height: blackColorSize)
                       
            content
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(2)
                .padding()
                .border(ImagePaint(image: Image(Images.frameImage), scale: 0.2), width: 10)
                .cornerRadius(2)
        }
    }
}

struct BlueBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Image(Images.backgroundImage)
            }
    }
}

struct FormTextField: ViewModifier {
    var iconSystemName: String
    var fontSize: CGFloat
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: iconSystemName)
                .foregroundColor(.black)
            
            content
                .foregroundColor(.white)
                .font(Font(Fonts.serif(size: fontSize)))
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.2))
                .shadow(color: .black, radius: 10)
        }
    }
}

extension View {
    func paintingFrame(blackColorSize: CGFloat, imageSize: CGFloat) -> some View {
        modifier(PaintingFrame(blackColorSize: blackColorSize, imageSize: imageSize))
    }
    
    func blueBackground() -> some View {
        modifier(BlueBackground())
    }
    
    func formTextField(iconSystemName: String, fontSize: CGFloat = 18) -> some View {
        modifier(FormTextField(iconSystemName: iconSystemName, fontSize: fontSize))
    }
}
