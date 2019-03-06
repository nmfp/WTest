//
//  HeaderImageView.swift
//  WTest
//
//  Created by Nuno Pereira on 04/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class HeaderImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageFromUrl(from urlString: String, completion: ((Error) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        
        imageUrlString = urlString
        image = nil
        
        if let imageCached = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageCached
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion?(error!)
                return
            }
            guard let resp = response as? HTTPURLResponse, 200...299 ~= resp.statusCode else {
                completion?(ApiError.badResponse)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
            }
        }.resume()
        
    }
}
