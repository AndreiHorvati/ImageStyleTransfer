//
//  PaintingViews.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 20.04.2023.
//

import SwiftUI
import PhotosUI

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct PaintingDetailsView: View {
    @State private var image: UIImage?
    @State private var showingExportDialog: Bool = false
    
    @State private var isShowingSavingImageAlert: Bool = false
    @State private var savingImageAlertText = String()
    @State private var isShowingShareSheet: Bool = false
    
    var painting: PaintingDetails
    private let imageSize: CGFloat = Dimensions.screenWidth / 1.4
    private let blackColorSize: CGFloat = Dimensions.screenWidth / 1.6
    
    var body: some View {
        VStack(spacing: 25) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .paintingFrame(blackColorSize: blackColorSize, imageSize: imageSize)
                    .shadow(color: .black, radius: 5)
            } else {
                ProgressView()
                    .paintingFrame(blackColorSize: blackColorSize, imageSize: imageSize)
                    .shadow(color: .black, radius: 5)
                    .onAppear {
                        AppDependencies.shared.paintingService.getImage(painting: painting) { success, imageData in
                            if success {
                                self.image = UIImage(data: imageData)
                            }
                        }
                    }
            }
            
            VStack(spacing: 40) {
                titleText
                    .font(Font(Fonts.serif(size: 24)))
                    .multilineTextAlignment(.center)
            
                detailsView
    
                exportButton
            }
            
            Spacer()
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .frame(width: Dimensions.screenWidth)
        .background {
            LinearGradient(colors: [painting.paintingType.backgroundColor.opacity(0.3), .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private var titleText: some View {
        Text("Painting created in ") +
        Text(painting.paintingType.name).bold() +
        Text(" style")
    }
    
    private func detailField(title: String, value: String) -> some View {
        HStack {
            Spacer()
            
            Text(title).bold()
            Text(value)
            
            Spacer()
        }
        .font(Font(Fonts.serif(size: 16)))
        .padding(20)
        .background {
            Color(Colors.darkGrey).opacity(0.4)
        }
        .cornerRadius(10)
    }
    
    private var detailsView: some View {
        VStack(spacing: 25) {
            detailField(title: Strings.numberOfIterationsTitle, value: "\(painting.numberOfIterations)")
            detailField(title: Strings.neuralNetworkModelTitle, value: NeuralNetworkModel(rawValue: painting.model)?.title ?? String())
        }
    }
    
    private var exportButton: some View {
        Button {
            self.showingExportDialog.toggle()
        } label: {
            Text(Strings.exportLabel)
                .foregroundColor(.white)
                .font(Font(Fonts.serif(size: 24)))
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background {
                    painting.paintingType.backgroundColor.opacity(0.5)
                        .background(Color(Colors.darkGrey))
                }
                .cornerRadius(16)
        }
        .confirmationDialog("", isPresented: $showingExportDialog) {
            Button {
                saveImageToPhotos(image: image)
            } label: {
                Text(Strings.saveToPhotosLabel)
            }
            
            Button {
                isShowingShareSheet.toggle()
            } label: {
                Text(Strings.shareLabel)
            }
        }
        .alert(isPresented: $isShowingSavingImageAlert) {
            Alert(
                title: Text("Save Image to Photos"),
                message: Text(savingImageAlertText),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(activityItems: [image as Any])
        }
    }
    
    func saveImageToPhotos(image: UIImage?) {
        guard let image else { return }
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = Date()
        } completionHandler: { [self] success, error in
            if let error = error {
                self.savingImageAlertText = Strings.savingImageToPhotosAlbumErrorText(error: error)
            } else {
                self.savingImageAlertText = Strings.savingImageToPhotosAlbumSuccessfullyText
            }
            
            self.isShowingSavingImageAlert = true
        }
    }
    
    func shareImage(image: UIImage?) {
        guard let image = image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { [self] activityType, completed, returnedItems, error in
            if let error = error {
                self.savingImageAlertText = "Error sharing image: \(error.localizedDescription)"
            } else if completed {
                self.savingImageAlertText = "The image was successfully shared."
            } else {
                self.savingImageAlertText = "Sharing was canceled."
            }
            
            self.isShowingSavingImageAlert = true
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct GalleryPaintingView: View {
    @State private var image: UIImage?
    
    var painting: PaintingDetails
    private let imageSize: CGFloat = Dimensions.screenWidth / 4.4
    private let blackColorSize: CGFloat = Dimensions.screenWidth / 4.6
    
    var body: some View {
        HStack(spacing: 15) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .paintingFrame(blackColorSize: blackColorSize, imageSize: imageSize)
                    .shadow(color: .black, radius: 5)
            } else {
                ProgressView()
                    .paintingFrame(blackColorSize: blackColorSize, imageSize: imageSize)
                    .shadow(color: .black, radius: 5)
                    .onAppear {
                        AppDependencies.shared.paintingService.getImage(painting: painting) { success, imageData in
                            if success {
                                self.image = UIImage(data: imageData)
                            }
                        }
                    }
            }
            
            Spacer()
            
            VStack(spacing: 5) {
                Text(painting.paintingType.name)
                    .font(Font(Fonts.serif(size: 16)).bold())
                    .multilineTextAlignment(.center)
                
                Text("Tap to see more details")
                    .font(Font(Fonts.serif(size: 8)))
            }
            
            Spacer()
        }
        .padding(18)
        .background {
            painting.paintingType.backgroundColor.opacity(0.2)
                .background(Color(Colors.darkGrey))
        }
        .cornerRadius(10)
        .shadow(color: .black, radius: 5)
        .frame(maxWidth: Dimensions.screenWidth * 0.9)
    }
}

struct PaintingView: View {
    var painting: PaintingType
    var pageType: PageType = .menu
    
    private static let frameImage = Image(Images.frameImage)
    
    private var imageSize: CGFloat {
        Dimensions.screenWidth / (pageType == .menu ? 3.2 : 2.6)
    }
    
    private var blackColorSize: CGFloat {
        Dimensions.screenWidth / (pageType == .menu ? 3 : 2.4)
    }
    
    var body: some View {
        VStack {
            Image(painting.imageName)
                .resizable()
                .paintingFrame(blackColorSize: blackColorSize, imageSize: imageSize)
            
            if pageType == .menu {
                Text(painting.name)
                    .font(Font(Fonts.serif(size: 16)))
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
    }
}
