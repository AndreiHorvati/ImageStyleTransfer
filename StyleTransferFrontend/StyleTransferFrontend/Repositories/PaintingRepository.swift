//
//  PaintingReposiotry.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation
import Alamofire

protocol PaintingRepository {
    func getImage(painting: PaintingDetails, completion: @escaping (_ success: Bool, _ imageData: Data) -> Void)
    
    func getAll(completion: @escaping (_ success: Bool, _ paintings: [PaintingDetails]) -> Void)
    
    func createPainting(paintingRequest: PaintingRequest, completion: @escaping () -> Void)
}

class PaintingURLRepository: PaintingRepository {
    func getImage(painting: PaintingDetails, completion: @escaping (_ success: Bool, _ imageData: Data) -> Void) {
        let request = URLUtils.createGetRequest(urlString: painting.imageURL)
        
        guard let request else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            if let data, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                completion(statusCode >= 200 && statusCode < 300, data)
            }
        }
        
        task.resume()
    }
    
    func getAll(completion: @escaping (_ success: Bool, _ paintings: [PaintingDetails]) -> Void) {
        let request = URLUtils.createGetRequest(urlString: URLUtils.paintingsURL)
        
        guard let request else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let paintings = try? JSONDecoder().decode([PaintingDetails].self, from: data),
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                completion(statusCode >= 200 && statusCode < 300, paintings)
            }
        }
        
        task.resume()
    }
    
    func createPainting(paintingRequest: PaintingRequest, completion: @escaping () -> Void) {
        let headers: HTTPHeaders = [.authorization("Token \(AppDependencies.shared.userDefaultsService.getToken() ?? String())")]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(paintingRequest.imageData, withName: "image", fileName: "\(UUID().description).jpg", mimeType: "jpg/png")
            
            if let typeData = paintingRequest.paintingType.id.data(using: .utf8) {
                multipartFormData.append(typeData, withName: "painting_type")
            }
            
            if let numberOfIterations = AppDependencies.shared.userDefaultsService.getNumberOfIterations(), numberOfIterations > 0, let data = "\(numberOfIterations)".data(using: .utf8) {
                multipartFormData.append(data, withName: Strings.numberOfIterationsKey)
            } else if let data = "10".data(using: .utf8) {
                multipartFormData.append(data, withName: Strings.numberOfIterationsKey)
            }
            
            if let model = AppDependencies.shared.userDefaultsService.getModel(), !model.isEmpty, let data = model.data(using: .utf8) {
                multipartFormData.append(data, withName: Strings.modelKey)
            } else if let data = "1".data(using: .utf8) {
                multipartFormData.append(data, withName: Strings.modelKey)
            }
        }, to: URLUtils.paintingsURL, headers: headers).response { _ in
            completion()
        }
    }
}
