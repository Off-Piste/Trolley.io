//
//  BasicViewController.swift
//  Trolley
//
//  Created by Harry Wright on 12.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Trolley
import Ardex

class Networking {
    
    class func downloadProducts(handler: @escaping ([Product], Error?) -> Void) {
        TRLNetworkManager.shared.get(.products).validate().responseJSON { (json, error) in
            if let error = error {
                handler([], error)
            } else {
                let products = json.arrayValue.flatMap { try? Product(json: $0) }
                handler(products, nil)
            }
        }
    }
    
}

class BasicCell : CollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override class func reuseID() -> String {
        return "BasicCell"
    }
    
    override func configureCell() {
        title.text = (self.datasourceItem as! Product).name
    }
    
}

class BasicDatasource: Datasource {
    override func cellClasses() -> [CellClass] {
        return [BasicCell.self]
    }
}

class BasicViewController: CollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl = self.refreshControl
        }
        
        self.datasource = BasicDatasource(collectionView: self.collectionView)
        Networking.downloadProducts { (products, error) in
            if error != nil { print("[Vivacity] Error \(error!.localizedDescription)"); return }
            self.datasource?.objects = products
        }
    }
    
    override func refreshOptions() {
        Networking.downloadProducts { (products, error) in
            if error != nil { return }
            self.datasource?.objects = products
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
}
