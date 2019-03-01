//
//  NetworkRouter.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation

protocol NetworkRouter {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [URLQueryItem]? { get }
}

extension NetworkRouter {
    var request: URLRequest {
        let request = URLRequest(url: url!)
        return request
    }
    
    var url: URL? {
        var components = URLComponents(string: baseUrl)
        components?.path = path
        components?.queryItems = parameters
        return components?.url
    }
}
