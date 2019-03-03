//
//  TextFieldListCell.swift
//  WTest
//
//  Created by Nuno Pereira on 02/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class TextFieldListCell: UITableViewCell {
    
    enum KeyboardType {
        case normalText, numbers
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.text = "test2"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        tf.delegate = delegate
        return tf
    }()
    
    
    weak var delegate: UITextFieldDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(textField)
        
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        textField.anchor(top: label.bottomAnchor, leading: label.leadingAnchor, bottom: bottomAnchor, trailing: label.trailingAnchor,padding: .zero, size: .init(width: 0, height: 64))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
