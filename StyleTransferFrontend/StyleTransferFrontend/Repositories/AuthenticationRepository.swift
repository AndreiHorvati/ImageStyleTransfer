//
//  AuthenticationRepository.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

protocol AuthenticationRepository {
    func loginUser(username: String, password: String,
                              completion: @escaping (_ success: Bool, _ token: String) -> Void)
}

class AuthenticationURLRepository: AuthenticationRepository {
    func loginUser(username: String, password: String,
                                     completion: @escaping (_ success: Bool, _ token: String) -> Void) {
        let userData = try? JSONEncoder().encode(User(username: username, password: password))
        let request = URLUtils.createPostRequest(urlString: URLUtils.loginURL, data: userData)
        
        guard let request else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let jsonData = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any],
               let token = jsonData["token"] as? String {
                completion(true, token)
            } else {
                completion(false, String())
            }
        }
        
        task.resume()
    }
}
