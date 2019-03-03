
//
//  AppConfiguration.swift
//  WTest
//
//  Created by Nuno Pereira on 03/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation

struct AppConfiguration {
    static var urlString: String? {
        get {
            if let infoFile = Bundle.main.path(forResource: "Info", ofType: "plist", inDirectory: nil),
                let dictionry = NSDictionary(contentsOfFile: infoFile) {
                return dictionry["DESTINATION_URL"] as? String
            }
            return nil
        }
    }
}
