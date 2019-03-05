//
//  HeaderView.swift
//  WTest
//
//  Created by Nuno Pereira on 04/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    var urlString: String! {
        didSet {
            imageView.loadImageFromUrl(from: urlString)
        }
    }
    
    lazy var imageView: HeaderImageView = {
        let iv = HeaderImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
