//
//  URLUtils.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 04.05.2023.
//

import Foundation

struct URLUtils {
    static let baseURL = "http://192.168.0.108:8010/"
    static let paintingsURL = URLUtils.baseURL + "paintings/"
    static let usersURL = URLUtils.baseURL + "users/"
    static let loginURL = URLUtils.baseURL + "authentication/"
    
    static func createGetRequest(urlString: String) -> URLRequest? {
        let url = URL(string: urlString)
        
        guard let url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(AppDependencies.shared.userDefaultsService.getToken() ?? String())", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    static func createPostRequest(urlString: String, data: Data?) -> URLRequest? {
        let url = URL(string: urlString)
        
        guard let url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: data?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }
}
