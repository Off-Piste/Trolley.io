//
//  ViewController.swift
//  Trolley
//
//  Created by harrytwright on 05/22/2017.
//  Copyright (c) 2017 harrytwright. All rights reserved.
//

import UIKit
import Trolley

@available(iOS 10.0, *)
class BasicVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var datasource: Datasource?
    
    var networkManager: Networkable!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.placeholder = "\(TRLUser.current.locale)"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = refreshController()
        
        self.datasource = Datasource(tableView: tableView)
        self.networkManager = NetworkManager(datasource: self.datasource!, vc: self)
        self.networkManager.startDownload {
            if !$0.containsError { self.datasource?.objects = $0.objects }
        }
    }
    
}

@available(iOS 10.0, *)
extension BasicVC {
    
    func refreshController() -> UIRefreshControl {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
        
        return rc
    }

    func startRefresh() {
        let rc = self.tableView.refreshControl
        
        networkManager.startRefresh {
            rc?.endRefreshing()
            if !$0.containsError { self.datasource?.objects = $0.objects }
        }
    }

}

@available(iOS 10.0, *)
extension BasicVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.numberOfItems(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        cell.product = datasource?.item(at: indexPath) as? Products
        
        return cell
    }
}

