//
//  HeaderImageView.swift
//  WTest
//
//  Created by Nuno Pereira on 04/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class HeaderImageView: UIImageView {
    func loadImageFromUrl(from string: String) {
        
        guard let url = URL(string: string) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                
                return
            }
            guard let resp = response as? HTTPURLResponse, 200...299 ~= resp.statusCode else {
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                self.image = imageToCache
            }
            
            
        }.resume()
        
    }
}
