//
//  Datasource.swift
//  Trolley
//
//  Created by Harry Wright on 31.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

struct Datasource {
    
    var tableView: UITableView
    
    var error: Error?
    
    var objects: [Any] {
        didSet {
            self.reloadData()
        }
    }
    
    var filteredObjects: [Any]? {
        didSet {
            self.reloadData()
        }
    }
    
    init(tableView: UITableView, objects: [Any] = []) {
        self.tableView = tableView
        self.objects = objects
    }
    
}

extension Datasource {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return objects.count
    }
    
    func item(at indexPath: IndexPath) -> Any? {
        return objects[indexPath.item]
    }
    
}

