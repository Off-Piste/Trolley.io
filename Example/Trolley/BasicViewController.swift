//
//  BasicViewController.swift
//  Trolley
//
//  Created by Harry Wright on 12.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Trolley
import Ardex

class BasicViewController: CollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datasource = BasicDatasource(collectionView: self.collectionView)
        self.datasource?.startDownload()
    }
    
}

extension BasicViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
}

fileprivate extension Datasource {
    
    func startDownload() {
        BasicNetworking.downloadProducts { (products, error) in
            if error != nil { print("[Vivacity] Error: \(error!.localizedDescription)"); return }
            self.objects = products
        }
    }
    
}
