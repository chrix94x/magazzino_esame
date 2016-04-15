//
//  Product.swift
//  CMarket
//
//  Created by christian scorza on 08/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit

class Product: NSObject {

    var name: String?
    var cost: Double?
    

    override init() {
    }
    
    
     init(name : String, cost: Double) {
        self.name = name
        self.cost  = cost
    }
    
}
