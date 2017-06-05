//
//  Datasource.swift
//  Trolley
//
//  Created by Harry Wright on 31.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

// MARK: For more info check HWCollectionView

/**
 
 */
struct Datasource {
    
    /// <#Description#>
    var tableView: UITableView?
    
    /// <#Description#>
    var error: Error?
    
    /// <#Description#>
    var containsError: Bool {
        return (error != nil)
    }
    
    /// <#Description#>
    var objects: [Any] {
        didSet {
            self.reloadData()
        }
    }
    
    /// <#Description#>
    var filteredObjects: [Any]? {
        didSet {
            self.reloadData()
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - objects: <#objects description#>
    init(tableView: UITableView, objects: [Any] = []) {
        self.tableView = tableView
        self.objects = objects
    }
    
    init(objects: [Any] = []) { self.objects = objects }
    
}

/**
 
 */
extension Datasource {
    
    /// <#Description#>
    func reloadData() {
        tableView?.reloadData()
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    func numberOfSections() -> Int {
        return 1
    }
    
    /// <#Description#>
    ///
    /// - Parameter section: <#section description#>
    /// - Returns: <#return value description#>
    func numberOfItems(in section: Int) -> Int {
        return objects.count
    }
    
    /// <#Description#>
    ///
    /// - Parameter indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func item(at indexPath: IndexPath) -> Any? {
        return objects[indexPath.item]
    }
    
}

