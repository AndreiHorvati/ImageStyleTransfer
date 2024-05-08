//
//  Paintings.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 19.03.2023.
//

import Alamofire
import SwiftUI

enum PaintingType: String, Codable, CaseIterable, Identifiable {
    case none
    case woodblock
    case edvardMunch
    case vanGogh
    case picasso
    case expressionism
    case nicolaeGrigorescu
    case stefanLuchian
    
    init?(id: String) {
        switch id {
        case "woodblock":
            self = .woodblock
        case "edvard_munch":
            self = .edvardMunch
        case "van_gogh":
            self = .vanGogh
        case "picasso":
            self = .picasso
        case "expressionism":
            self = .expressionism
        case "nicolae_grigorescu":
            self = .nicolaeGrigorescu
        case "stefan_luchian":
            self = .stefanLuchian
        default:
            return nil
        }
    }
    
    var id: String {
        switch self {
        case .woodblock:
            return "woodblock"
        case .edvardMunch:
            return "edvard_munch"
        case .vanGogh:
            return "van_gogh"
        case .picasso:
            return "picasso"
        case .expressionism:
            return "expressionism"
        case .nicolaeGrigorescu:
            return "nicolae_grigorescu"
        case .stefanLuchian:
            return "stefan_luchian"
        default:
            return String()
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .woodblock:
            return .white
        case .edvardMunch:
            return .orange
        case .vanGogh:
            return .blue
        case .picasso:
            return .gray
        case .expressionism:
            return .red
        case .nicolaeGrigorescu:
            return Color(red: 1.0, green: 0.99, blue: 0.82)
        case .stefanLuchian:
            return .yellow
        default:
            return .black
        }
    }
    
    var imageName: String {
        return self.id
    }
    
    var name: String {
        return self.id.replacingOccurrences(of: "_", with: " ").capitalized
    }
}

struct PaintingRequest: Codable {
    let imageData: Data
    let paintingType: PaintingType
}

struct PaintingDetails: Identifiable, Codable, Hashable {
    let imageURL: String
    let paintingType: PaintingType
    let numberOfIterations: Int
    let model: String
    
    var id: String {
        imageURL
    }
    
    init(imageURL: String, paintingType: String, numberOfIterations: Int, model: String) {
        self.imageURL = imageURL
        self.paintingType = PaintingType(id: paintingType) ?? .none
        self.numberOfIterations = numberOfIterations
        self.model = model
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let encodedImageURL = try container.decode(String.self, forKey: .imageURL)
        let encodedPaintingType = try container.decode(String.self, forKey: .paintingType)
        let encodedNumberOfIterations = try container.decode(Int.self, forKey: .numberOfIterations)
        let encodedModel = try container.decode(String.self, forKey: .model)
        
        self.init(imageURL: encodedImageURL, paintingType: encodedPaintingType, numberOfIterations: encodedNumberOfIterations, model: encodedModel)
    }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image", paintingType = "painting_type",
             numberOfIterations = "number_of_iterations", model = "model"
    }
}
