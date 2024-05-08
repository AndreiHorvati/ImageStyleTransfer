//
//  AppDependencies.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

class AppDependencies {
    let userService: UserService = UserURLService(userRepository: UserURLRepository())
    let paintingService: PaintingService = PaintingURLService(paintingRepository: PaintingURLRepository())
    let userDefaultsService: UserDefaultsService = BasicUserDefaultsService(userDefaultsRepository: BasicUserDefaultsRepository())
    let authenticationService: AuthenticationService = AuthenticationURLService(authenticationRepository: AuthenticationURLRepository())
    
    static let shared = AppDependencies()
    
    private init() {}
}
