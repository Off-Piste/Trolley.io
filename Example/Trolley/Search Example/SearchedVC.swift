//
//  SearchedVC.swift
//  Trolley
//
//  Created by Harry Wright on 05.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Trolley

class SearchedVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var discountValueLabel: UILabel!
    
    var networkManager: SearchNetworkable!
    
    var searchableProduct: SearchableProducts?
    
    var product: Product? {
        didSet {
            self.activityIndicator.stopAnimating()
            print(product as Any)
            configView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        guard let sp = searchableProduct else { self.dismiss(animated: true, completion: nil); return }
        networkManager = SearchNetworkManager(searchableProduct: sp, vc: self)
        networkManager.downloadProduct {
            if $0.containsError && !$0.containsItem { print($0.error!); return }
            self.product = $0.item as? Product
        }
    }
    
    func configView() {
        self.itemLabel.text = product!.name
        self.companyLabel.text = product!.company
        self.priceLabel.text = "\(product!.price)"
        self.discountLabel.text = "\(product!.discount)"
        self.discountValueLabel.text = "\(product!.discountValue)"
    }
    
}
