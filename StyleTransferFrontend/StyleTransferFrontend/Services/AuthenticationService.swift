//
//  AuthenticationService.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

protocol AuthenticationService{
    func loginUser(username: String, password: String,
                              completion: @escaping (_ success: Bool, _ token: String) -> Void)
}

class AuthenticationURLService: AuthenticationService {
    private let authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
    
    func loginUser(username: String, password: String,
                              completion: @escaping (_ success: Bool, _ token: String) -> Void) {
        authenticationRepository.loginUser(username: username, password: password, completion: completion)
    }
}
