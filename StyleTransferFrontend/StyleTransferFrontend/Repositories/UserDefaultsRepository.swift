//
//  UserDefaultsRepository.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

protocol UserDefaultsRepository {
    func getToken() -> String?
    func setToken(_ token: String?)
    func removeToken()
    
    func getNumberOfIterations() -> Int?
    func setNumberOfIterations(_ numberOfIterations: Int?)
    func removeNumberOfIterations()
    
    func getModel() -> String?
    func setModel(_ model: String?)
    func removeModel()
}

class BasicUserDefaultsRepository: UserDefaultsRepository {
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: Strings.tokenKey)
    }
    
    func setToken(_ token: String?) {
        UserDefaults.standard.set(token, forKey: Strings.tokenKey)
    }
    
    func removeToken() {
        UserDefaults.standard.removeObject(forKey: Strings.tokenKey)
    }
    
    func getNumberOfIterations() -> Int? {
        return UserDefaults.standard.integer(forKey: Strings.numberOfIterationsKey)
    }
    
    func setNumberOfIterations(_ numberOfIterations: Int?) {
        UserDefaults.standard.set(numberOfIterations, forKey: Strings.numberOfIterationsKey)
    }
    
    func removeNumberOfIterations() {
        UserDefaults.standard.removeObject(forKey: Strings.numberOfIterationsKey)
    }
    
    func getModel() -> String? {
        return UserDefaults.standard.string(forKey: Strings.modelKey)
    }
    
    func setModel(_ model: String?) {
        UserDefaults.standard.set(model, forKey: Strings.modelKey)
    }
    
    func removeModel() {
        UserDefaults.standard.removeObject(forKey: Strings.modelKey)
    }
}
