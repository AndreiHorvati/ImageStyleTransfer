//
//  PaintingService.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation
import Alamofire

protocol PaintingService {
    func getImage(painting: PaintingDetails, completion: @escaping (_ success: Bool, _ imageData: Data) -> Void)
    
    func getAll(completion: @escaping (_ success: Bool, _ paintings: [PaintingDetails]) -> Void)
    
    func createPainting(paintingRequest: PaintingRequest, completion: @escaping () -> Void)
}

class PaintingURLService: PaintingService {
    private let paintingRepository: PaintingRepository
    
    init(paintingRepository: PaintingRepository) {
        self.paintingRepository = paintingRepository
    }
    
    func getImage(painting: PaintingDetails, completion: @escaping (_ success: Bool, _ imageData: Data) -> Void) {
        paintingRepository.getImage(painting: painting, completion: completion)
    }
    
    func getAll(completion: @escaping (_ success: Bool, _ paintings: [PaintingDetails]) -> Void) {
        paintingRepository.getAll(completion: completion)
    }
    
    func createPainting(paintingRequest: PaintingRequest, completion: @escaping () -> Void) {
        paintingRepository.createPainting(paintingRequest: paintingRequest, completion: completion)
    }
}
