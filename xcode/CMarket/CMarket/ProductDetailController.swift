//
//  ProductDetailController.swift
//  CMarket
//
//  Created by christian scorza on 24/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit

class ProductDetailController: UIViewController {


    
    var p : Product?
    
    @IBOutlet weak var LabelDescriptionProduct: UILabel!
    @IBOutlet weak var LabelPriceProduct: UILabel!
    @IBOutlet weak var LabelQuantityProduct: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelDescriptionProduct.text = p?.descr
        LabelPriceProduct.text = "\(p!.cost!)"
        LabelQuantityProduct.text = "\(p!.quantity!)"
        
        
    }
    
    
    
    

  
}
