//
//  User.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 16.04.2023.
//

import Alamofire

struct User: Codable {
    var email: String?
    let username: String?
    let password: String?
    
    var parameters: Parameters {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    
    var errors: String {
        var errorsArray = [String]()
        
        if let username, !username.isEmpty {
            errorsArray.append(Strings.usernameLabel + ": " + username)
        }
        
        if let email, !email.isEmpty {
            errorsArray.append(Strings.emailLabel + ": " + email)
        }
        
        if let password, !password.isEmpty {
            errorsArray.append(Strings.passwordLabel + ": " + password)
        }
        
        return errorsArray.joined(separator: "\n")
    }
}
