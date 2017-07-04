//
//  Cell.swift
//  Trolley
//
//  Created by Harry Wright on 31.05.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Trolley
import PromiseKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var companyTitle: UILabel!
    
    @IBOutlet weak var priceTitle: UILabel!
    
    var product: Product? {
        didSet {
            configCell()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCell() {
        self.itemTitle.text = self.product!.name
        self.companyTitle.text = self.product!.company
        self.priceTitle.text = "\(self.product!.price)"
    }
    
}
