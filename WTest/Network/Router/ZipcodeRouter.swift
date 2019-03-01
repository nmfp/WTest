//
//  ZipcodeRouter.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation

enum ZipcodeRouter: NetworkRouter {
    case zipcodes
    
    var baseUrl: String {
        switch self {
        case .zipcodes:
            return "https://raw.githubusercontent.com"
        }
    }
    
    var path: String {
        switch self {
        case .zipcodes:
            return "/centraldedados/codigos_postais/master/data/codigos_postais.csv"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .zipcodes:
            return nil
        }
    }
}
