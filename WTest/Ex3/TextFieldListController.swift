//
//  TextFieldListController.swift
//  WTest
//
//  Created by Nuno Pereira on 02/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class TextFieldListController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TextFieldListCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        print("teclado")
        //        guard let userInfo = notification.userInfo as? [String: String] else { return }
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        self.tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        print("teclado")
        //        guard let userInfo = notification.userInfo as? [String: String] else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        
        self.tableView.contentInset = .zero
        self.tableView.scrollIndicatorInsets = .zero
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TextFieldListCell
        cell.delegate = self
        return cell
    }
    
    

}
