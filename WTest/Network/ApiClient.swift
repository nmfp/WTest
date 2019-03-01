//
//  ApiClient.swift
//  WTest
//
//  Created by Nuno Pereira on 28/02/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation

enum ApiResponse<T> {
    case success(T)
    case error(Error)
}

enum ApiError: Error {
    case unknown, badResponse, badRequest, parseError
}

protocol ApiClient {
    var session: URLSession { get }
    func getFile<T: Codable>(with request: URLRequest, completion: @escaping (ApiResponse<T>) -> Void)
}

extension ApiClient {
    
    var session: URLSession {
        return URLSession.shared
    }
    
    func getFile<T: Codable>(with request: URLRequest, completion: @escaping (ApiResponse<T>) -> Void) {
        guard let url = request.url else {
            completion(.error(ApiError.badRequest))
            return
        }
        session.downloadTask(with: url) { (url, resp, error) in
            guard error == nil else {
                completion(.error(error!))
                return
            }
            
            guard let resp = resp as? HTTPURLResponse, 200...299 ~= resp.statusCode else {
                completion(.error(ApiError.badResponse))
                return
            }
            
            guard let value = url as? T else {
                completion(.error(ApiError.parseError))
                return
            }
            
            completion(.success(value))
        }.resume()
    }
}
