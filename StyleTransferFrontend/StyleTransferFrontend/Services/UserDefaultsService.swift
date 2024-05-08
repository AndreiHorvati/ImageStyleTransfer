//
//  UserDefaultsService.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

protocol UserDefaultsService {
    func getToken() -> String?
    func setToken(_ token: String?)
    func removeToken()
    
    func getNumberOfIterations() -> Int?
    func setNumberOfIterations(_ numberOfIterations: Int?)
    func removeNumberOfIterations()
    
    func getModel() -> String?
    func setModel(_ model: String?)
    func removeModel()
    
    func removeAll()
}

class BasicUserDefaultsService: UserDefaultsService {
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func getToken() -> String? {
        return userDefaultsRepository.getToken()
    }
    
    func setToken(_ token: String?) {
        userDefaultsRepository.setToken(token)
    }
    
    func removeToken() {
        userDefaultsRepository.removeToken()
    }
    
    func getNumberOfIterations() -> Int? {
        return userDefaultsRepository.getNumberOfIterations()
    }
    
    func setNumberOfIterations(_ numberOfIterations: Int?) {
        userDefaultsRepository.setNumberOfIterations(numberOfIterations)
    }
    
    func removeNumberOfIterations() {
        userDefaultsRepository.removeNumberOfIterations()
    }
    
    func getModel() -> String? {
        return userDefaultsRepository.getModel()
    }
    
    func setModel(_ model: String?) {
        userDefaultsRepository.setModel(model)
    }
    
    func removeModel() {
        userDefaultsRepository.removeModel()
    }
    
    func removeAll() {
        removeModel()
        removeToken()
        removeNumberOfIterations()
    }
}
