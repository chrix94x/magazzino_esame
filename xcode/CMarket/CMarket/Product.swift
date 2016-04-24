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
    var quantity: Int?
    
    override init() {
    }
    
    
     init(descr : String, cost: Double ,quantity: Int) {
        
        self.cost  = cost
        self.descr = descr
        self.quantity = quantity
    }
    
    
     override var description: String {
        let s = "\(cost!) -  \(descr!)"
        return s
    }
    
}
