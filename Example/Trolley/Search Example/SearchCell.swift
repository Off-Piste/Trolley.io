//
//  SearchCell.swift
//  Trolley
//
//  Created by Harry Wright on 05.06.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Trolley

class SearchCell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var companyTitle: UILabel!
    
    var product: SearchableProducts? {
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
        self.itemTitle.text = self.product!.productName
        self.companyTitle.text = self.product!.companyName
    }

}
