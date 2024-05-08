//
//  Constants.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 19.03.2023.
//

import UIKit

struct Images {
    static let backgroundImage = "background"
    static let frameImage = "frame"
}

struct Dimensions {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let minimumNumberOfIterations: Double = 5
    static let maximumNumberOfIterations: Double = 50
}

struct Strings {
    static let cameraLabel = "Camera"
    static let photoLibraryLabel = "Photo Library"
    static let takeAPictureLabel = "Take a picture"
    
    static let loginLabel = "Login"
    static let createAccountLabel = "Create Account"
    
    static let usernameLabel = "Username"
    static let emailLabel = "Email"
    static let passwordLabel = "Password"
    static let confirmPasswordLabel = "Confirm Password"
    static let successfullyCreatedAccountLabel = "The account has been created successfully!"
    static let failedAuthentication = "Authentication failed!"
    
    static let tokenKey = "token"
    static let numberOfIterationsKey = "number_of_iterations"
    static let modelKey = "model"
    
    static let paintingMenuTabTitle = "Create"
    static let galleryTabTile = "Gallery"
    static let accountTabTitle = "Account"
    
    static let settingsLabel = "Settings"
    static let logoutButtonLabel = "Logout"
    static func numberOfIterationsLabel(number: Int) -> String {
        "Number of iterations: \(number)"
    }
    static let modelLabel = "Model"
    static let vgg19Title = "VGG-19"
    static let resNet50Title = "ResNet-50"
    static let inceptionV3Title = "Inception-v3"

    static let numberOfIterationsTitle = "Number of iterations:"
    static let neuralNetworkModelTitle = "Neural network model:"
    static let exportLabel = "Export"
    static let allLabel = "All"
    
    static let saveToPhotosLabel = "Save to photos"
    static let shareLabel = "Share"
    
    static let savingImageToPhotosAlbumSuccessfullyText =  "Image was successfully saved to photos album"
    static func savingImageToPhotosAlbumErrorText(error: Error) -> String {
        return "There was an error while saving your image: \(error.localizedDescription)"
    }
}

struct Fonts {
    static func serif(size: CGFloat) -> UIFont {
        let design = UIFontDescriptor.SystemDesign.serif
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(design)!
        
        return UIFont.init(descriptor: descriptor, size: size)
    }
}

struct Colors {
    static let darkGrey = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
    static let darkBlue = UIColor(red: 0 / 255, green: 72 / 255, blue: 129 / 255, alpha: 1)
}
