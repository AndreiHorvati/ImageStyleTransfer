//
//  UserRepository.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

protocol UserRepository {
    func createUser(username: String, email: String, password: String,
                    completion: @escaping (_ success: Bool, _ user: User) -> Void)
}

class UserURLRepository: UserRepository {
    func createUser(username: String, email: String, password: String,
                    completion: @escaping (_ success: Bool, _ user: User) -> Void) {
        let userData = try? JSONEncoder().encode(User(email: email, username: username, password: password))
        let request = URLUtils.createPostRequest(urlString: URLUtils.usersURL, data: userData)
        
        guard let request else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let user = try? JSONDecoder().decode(User.self, from: data),
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                completion(statusCode >= 200 && statusCode < 300, user)
            }
        }
        
        task.resume()
    }
}
