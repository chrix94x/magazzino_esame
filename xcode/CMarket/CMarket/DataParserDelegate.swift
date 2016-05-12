//
//  DataParserDelegate.swift
//  CMarket
//
//  Created by christian scorza on 24/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import Foundation


public protocol DataParserDelegate {
    
    func parseJSON(data: NSData?)
        
    
}
