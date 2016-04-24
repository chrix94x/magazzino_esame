//
//  Product.swift
//  CMarket
//
//  Created by christian scorza on 08/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit

class Product: NSObject {

    var descr: String?
    var cost: Double?
    

    override init() {
    }
    
    
     init(descr : String, cost: Double) {
        self.cost  = cost
        self.descr = descr
    }
    
    
     override var description: String {
        let s = "\(cost!) -  \(descr!)"
        return s
    }
    
}
