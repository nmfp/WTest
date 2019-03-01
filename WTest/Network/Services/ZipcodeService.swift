//
//  ZipcodeService.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation

struct ZipcodeService: ApiClient {
    
    func getZipcpdes(_ router: NetworkRouter, completion: @escaping (ApiResponse<[Zipcode]>) -> Void) {
        let request = router.request
        getFile(with: request) { (resp: ApiResponse<URL>) in
            
            do {
                switch resp {
                case .success(let fileUrl):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let zipcodes = try decoder.decode([Zipcode].self, from: try self.handleFile(with: fileUrl))
                    completion(.success(zipcodes))
                case .error(let error):
                    completion(.error(error))
                }
            } catch {
                completion(.error(error))
            }
        }
    }
    
    
    private func handleFile(with url: URL) throws -> Data {
        let dataAsString = try String(contentsOf: url, encoding: .utf8)
        
        var zipcodeRows = dataAsString.components(separatedBy: CharacterSet.newlines)
            .dropLast()
            .map({ $0.components(separatedBy: ",") })
            .map({ Array($0.dropFirst($0.count - 3)) })
        
        let zipcodeTitleRow = zipcodeRows.removeFirst()
        
        let value = zipcodeRows.map( { (row: [String]) -> [String: String] in
            var dict = [String: String]()
            for (index, title) in zipcodeTitleRow.enumerated() {
                dict[title] = row[index]
            }
            return dict
        } )
        
        return try JSONEncoder().encode(value)
    }
    
}
