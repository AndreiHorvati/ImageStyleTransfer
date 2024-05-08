//
//  CameraViews.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 27.03.2023.
//

import SwiftUI

class CameraViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var cameraView: CameraView
    
    init(cameraView: CameraView) {
        self.cameraView = cameraView
    }
    
    func makeImageSquare(_ image: UIImage) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: CGSize(width: 512, height: 512)))
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        self.cameraView.image = makeImageSquare(selectedImage)
        self.cameraView.isPresented.wrappedValue.dismiss()
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> CameraViewCoordinator {
        return CameraViewCoordinator(cameraView: self)
    }
}
