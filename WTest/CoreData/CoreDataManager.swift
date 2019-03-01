//
//  CoreDataManager.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ZipcodeModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let err = error {
                print("Error loading store: \(err)")
            }
        })
        return container
    }()
}
