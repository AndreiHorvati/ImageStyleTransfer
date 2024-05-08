//
//  NeuralNetworkModel.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

enum NeuralNetworkModel: String , CaseIterable {
    case vgg19 = "1"
    case resNet50 = "2"
    case inceptionV3 = "3"
    
    var title: String {
        switch self {
        case .vgg19:
            return Strings.vgg19Title
        case .resNet50:
            return Strings.resNet50Title
        case .inceptionV3:
            return Strings.inceptionV3Title
        }
    }
}
