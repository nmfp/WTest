//
//  ZipcodesController.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit
import CoreData

class ZipcodesController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    let zipcodeCellId = "zipcodeCellId"
    
    lazy var fetchedResultsController: NSFetchedResultsController<Zipcode> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Zipcode> = Zipcode.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "numCodPostal", ascending: true)
        ]
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
//        request.fetchLimit = 100
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error)
        }
        
        return fetchResultsController
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        return tableView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "No Zipcodes to show..."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "Search zipcode..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    var tableViewBottomAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fetchZipcodes()
        setupViews()
        setupKeyboardObservers()
        tableView.register(ZipcodeCell.self, forCellReuseIdentifier: zipcodeCellId)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.tableViewBottomAnchor.constant = -keyboardFrame.height
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.tableViewBottomAnchor.constant = 0.0
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupViews() {
        view.addSubview(searchTextField)
        view.addSubview(statusLabel)
        view.addSubview(tableView)
        
        searchTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: CGSize(width: 0, height: 50))
        statusLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero, size: .zero)
        tableView.anchor(top: searchTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .zero)
        tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomAnchor.isActive = true
    }
    
    private func fetchZipcodes() {
        if fetchedResultsController.fetchedObjects?.count ?? 0 == 0 {
            #if DEBUG
            print("base de dados vazia")
            #endif
            let zipcodeClient = ZipcodeService()
            zipcodeClient.getZipcpdes(ZipcodeRouter.zipcodes) { (resp) in
                DispatchQueue.main.async {
                    switch resp {
                    case .success(let zipcodes):
                        self.tableView.reloadData()
                    case .error(let error):
                        print(error)
                    }
                }
            }
        } else {
            statusLabel.isHidden = true
            tableView.isHidden = false
            #if DEBUG
            print("Ja existem dados na base de dados")
            #endif
        }
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: zipcodeCellId, for: indexPath) as! ZipcodeCell
        let zipcode = fetchedResultsController.object(at: indexPath)
        cell.zipcode = zipcode
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        statusLabel.isHidden = true
        tableView.isHidden = false
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
}


class ZipcodeCell: UITableViewCell {
    
    var zipcode: Zipcode! {
        didSet {
            textLabel?.text = "\(zipcode.numCodPostal ?? "")-\(zipcode.extCodPostal ?? ""), \(zipcode.desigPostal ?? "")"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ZipcodesController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //FIXME: String manipulation need to be improved
        var searchText = textField.text!
        let s = searchText.index(searchText.startIndex, offsetBy: range.location)
        let x = searchText.index(s, offsetBy: range.length)
        var s2 = searchText[..<s]
        var x2 = searchText[s...]
        s2.replaceSubrange(Range(range, in: textField.text!)!, with: string)
        let s3 = String(s2 + x2)
        print("text: ",s3)
        var predicate: NSPredicate?
        if !s3.isEmpty {
            predicate = NSPredicate(format: "desigPostal contains[cd] %@", s3)
        } else {
            predicate = nil
        }
        
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print(error)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
}
