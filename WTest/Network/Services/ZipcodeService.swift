//
//  ZipcodeService.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation
import CoreData

struct ZipcodeService: ApiClient {
    
    func getZipcpdes(_ router: NetworkRouter, completion: @escaping (ApiResponse<[JSONZipcode]>) -> Void) {
        let request = router.request
        getFile(with: request) { (resp: ApiResponse<URL>) in
            
            do {
                switch resp {
                case .success(let fileUrl):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    var zipcodes = try decoder.decode([JSONZipcode].self, from: try self.handleFile(with: fileUrl))
                    
                    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                    
                    zipcodes.forEach({ code in
                        let zipcode = Zipcode(context: privateContext)
                        zipcode.numCodPostal = code.numCodPostal
                        zipcode.extCodPostal = code.extCodPostal
                        zipcode.desigPostal = code.desigPostal
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                        completion(.success(zipcodes))
                    } catch {
                        completion(.error(error))
                    }
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
