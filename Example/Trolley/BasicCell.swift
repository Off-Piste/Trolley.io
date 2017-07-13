//
//  BasicCell.swift
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Ardex
import Trolley

class BasicCell : CollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    override class func reuseID() -> String {
        return "BasicCell"
    }
    
    override func configureCell() {
        title.text = (self.datasourceItem as! Product).name
    }
    
}
