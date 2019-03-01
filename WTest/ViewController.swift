//
//  ViewController.swift
//  WTest
//
//  Created by Nuno Pereira on 28/02/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let client = ZipcodeService()
        client.getZipcpdes(ZipcodeRouter.zipcodes) { (zipcodesResponse) in
            switch zipcodesResponse {
            case .success(let zipcodes):
                print(zipcodes)
            case .error(let error):
                print(error)
            }
        }
    }


}

