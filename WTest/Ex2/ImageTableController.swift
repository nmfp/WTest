//
//  ImageTableController.swift
//  WTest
//
//  Created by Nuno Pereira on 04/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class ImageTableController: UITableViewController {
    
    private let numberElements = 50
    private let cellId = "cellId"
    private let imageUrl = "https://upload.wikimedia.org/wikipedia/commons/3/34/Wingman.jpg"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupTableView()    
        setupNavigationBar()
    }
    
    private func setupNavigationBar(with factor: CGFloat = 0.0) {
        navigationController?.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: factor)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(white: 1.0 - factor, alpha: 1.0)]
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}

extension ImageTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberElements
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        cell.detailTextLabel?.text = "Row: \(indexPath.row)"
        cell.backgroundColor = .black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView()
        header.urlString = imageUrl
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.bounds.width / 2
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalOffset = scrollView.contentSize.height - scrollView.frame.height + scrollView.adjustedContentInset.bottom + scrollView.adjustedContentInset.top
        let offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let colorFactor = offset / totalOffset
        setupNavigationBar(with: colorFactor)
    }
}
