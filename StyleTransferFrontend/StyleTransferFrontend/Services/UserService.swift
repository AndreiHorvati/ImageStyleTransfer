//
//  UserService.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

protocol UserService {
    func createUser(username: String, email: String, password: String,
                    completion: @escaping (_ success: Bool, _ user: User) -> Void)
}

class UserURLService: UserService {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func createUser(username: String, email: String, password: String,
                    completion: @escaping (_ success: Bool, _ user: User) -> Void) {
        userRepository.createUser(username: username, email: email, password: password, completion: completion)
    }
}
