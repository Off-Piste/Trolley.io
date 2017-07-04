//
//  SearchVC.swift
//  Trolley
//
//  Created by Harry Wright on 05.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import Trolley

protocol SearchNetworkable {
    
    func downloadProduct(callback: @escaping (DatasourceItem) -> Void)
    
}

struct SearchNetworkManager {
    
    var searchableProduct: SearchableProducts
    
    var viewController: UIViewController
    
    init(searchableProduct: SearchableProducts, vc: UIViewController) {
        self.searchableProduct = searchableProduct
        self.viewController = vc
    }
    
}

struct DatasourceItem {
    
    var item: Any?
    
    var error: Error?
    
    var containsError: Bool {
        return error != nil
    }
    
    var containsItem: Bool {
        return item != nil
    }
}

extension SearchNetworkManager : SearchNetworkable  {
    
    func downloadProduct(callback: @escaping (DatasourceItem) -> Void) {
        print(searchableProduct._id)
        Product.getProduct(with: searchableProduct._id).then { (item) -> Void in
            callback(DatasourceItem(item: item, error: nil))
        }.catch { (error) in
            let item = DatasourceItem(item: nil, error: error)
            callback(item)
            
            self.postAlert(for: error, to: self.viewController)
        }
    }
    
    func postAlert(
        for error: Error,
        to vc: UIViewController,
        withStyle style: UIAlertControllerStyle = .alert
        )
    {
        let alert = PMKAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        _ = alert.addActionWithTitle(title: "Okay")
        vc.promise(alert).tap {
            print($0)
        }
    }
}

@available(iOS 10.0, *)
class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activIndicator: UIActivityIndicatorView!
    
    var datasource: Datasource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.placeholder = "\(TRLUser.current.locale.currencyCode ?? "nil")"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        self.datasource = Datasource(tableView: tableView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchedVC {
            if let product = sender as? SearchableProducts {
                destination.searchableProduct = product
            }
        }
    }
    
}

@available(iOS 10.0, *)
extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        firstly { _ -> Promise<SearchablePromiseReponse> in
            self.activIndicator.startAnimating()
            self.activIndicator.isHidden = false
            
            return SearchableProducts.getAll()
        }.then { response -> Promise<[SearchableProducts]> in
            return response.search(for: searchText)
        }.then { (items) -> Void in
            self.datasource?.objects = items
        }.always {
            self.activIndicator.stopAnimating()
            self.activIndicator.isHidden = true
        }.catch { (error) in
            if searchText.isEmpty { searchBar.resignFirstResponder(); return }
            self.postAlert(for: error)
        }
    }
    
    func postAlert(
        for error: Error,
        withStyle style: UIAlertControllerStyle = .alert
        )
    {
        let alert = PMKAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        _ = alert.addActionWithTitle(title: "Okay")
        self.promise(alert).tap {
            print($0)
        }
    }
    
}

@available(iOS 10.0, *)
extension SearchVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.numberOfItems(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        cell.product = datasource?.item(at: indexPath) as? SearchableProducts
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = datasource?.item(at: indexPath) as? SearchableProducts else {
            return
        }
        
        self.performSegue(withIdentifier: "toSearched", sender: item)
    }
    
}
