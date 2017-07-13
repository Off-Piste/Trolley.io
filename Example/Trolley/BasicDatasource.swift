//
//  BasicDatasource.swift
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Ardex

class BasicDatasource: Datasource {
    
    override func collectionCellClasses() -> [Any] {
        return [BasicCell.self]
    }
    
}
