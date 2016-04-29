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

class SecondViewController: UIViewController, DataParserDelegate {

    let sharedInstance = TCPStreamer.sharedInstance


    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    @IBAction func AskJson(sender: AnyObject) {
        
        self.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
        sendCommand("list")
        
    }
    
    
    func sendCommand(var cmd: String)  {
 
        let command = "{\"command\":"
        let close = "}"
        cmd = command + "\"" + cmd + "\"" + close + "\n"

        
        print(cmd)
        
        self.sharedInstance.writeToServer(cmd)
        
        //self.sharedInstance.writeToServer("wearehere")
    }

    
    
    
    func parseJSON(data: NSData?){
        if data == nil{
            return
        }
        
        do {
            let json : NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSArray
            
            for dict in json {
                // print(dict)
                let id = dict["id"] as? String
                let desc = dict["descrizione"] as? String
                let cost = dict["prezzo"] as? NSNumber
                let quantity = dict["quantita"] as? NSNumber
                let barcode=dict["barcode"] as? String
                let c = Product(descr: desc!, cost: cost!.doubleValue, quantity: quantity!.integerValue , barcode: barcode!)
                print(c)
            }
        }
        catch
        {
            print ("Json error")
        }
    }    // processJSON
    

    
}


