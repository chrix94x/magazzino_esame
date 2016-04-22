//
//  SecondViewController.swift
//  CMarket
//
//  Created by christian scorza on 08/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit


let host = "localhost"
let port : UInt32 = 2000

class SecondViewController: UIViewController {


    let sharedInstance = TCPStreamer.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    @IBAction func AskJson(sender: AnyObject) {
        
        self.sharedInstance.openSocketsIfNeeded(host,onPort: port)
        sendCommand("list")
        
    }
    
    
    func sendCommand(var cmd: String)  {
 
        var command = "{\"command\":"
        let close = "}"
        cmd = command + "\"" + cmd + "\"" + close + "\n"

        
        print(cmd)
        
        self.sharedInstance.writeToServer(cmd)
        
        //self.sharedInstance.writeToServer("wearehere")
    }

    
    
    
}


