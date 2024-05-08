//
//  GalleryView.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 19.04.2023.
//

import SwiftUI

struct GalleryView: View {
    @State private var paintings = [PaintingDetails]()
    @State private var selectedType: PaintingType = .none
    @State private var selectedPainting: PaintingDetails? = nil
    @State private var isPaintingDetailsPresented: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                ForEach(selectedType == .none ? paintings : paintings.filter {
                    $0.paintingType == selectedType }, id: \.self) { painting in
                        GalleryPaintingView(painting: painting)
                            .shadow(color: .black, radius: 5)
                            .onTapGesture {
                                self.selectedPainting = painting
                            }
                }
                .frame(width: Dimensions.screenWidth)
                .padding()
            }
        }
        .blueBackground()
        .onAppear {
            AppDependencies.shared.paintingService.getAll { success, paintings in
                if success {
                    self.paintings = paintings
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                paintingTypesMenu
            }
        }
        .sheet(item: $selectedPainting, onDismiss: { selectedPainting = nil }) { painting in
            PaintingDetailsView(painting: painting)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    var paintingTypesMenu: some View {
        Menu {
            ForEach(PaintingType.allCases) { type in
                Button {
                    self.selectedType = type
                } label: {
                    HStack {
                        Text(type != .none ? type.name : Strings.allLabel)
                        
                        if type == selectedType {
                            Image(systemName: "checkmark")
                        }
                        
                        Image(type.imageName)
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedType != .none ? selectedType.name : Strings.allLabel)
                
                Image(systemName: "chevron.down")
            }
            .foregroundColor(.white)
        }
    }
}
