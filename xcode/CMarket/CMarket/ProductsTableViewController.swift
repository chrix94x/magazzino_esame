//
//  ProductsTableViewController.swift
//  CMarket
//
//  Created by christian scorza on 08/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//




//SCRITTO TUTTO DA NOI !!!!!! 




import UIKit

class ProductsTableViewController: UITableViewController, DataParserDelegate{

    var products:  [Product]?
    let sharedInstance = TCPStreamer.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDataFromServer()
    }



    func loadDataFromServer_FAKE(){
  //      let p1 = Product(descr: "banane", cost: 3)
  //      let p2 = Product(descr: "pere", cost: 4)
        
        products = [Product]()
        
//        products?.append(p1)
//        products?.append(p2)
    }
    
    func loadDataFromServer(){
        
        products = [Product]()

        self.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
        sendCommand("list")
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if products != nil{
            let n = products!.count
            return n
        }
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCellID", forIndexPath: indexPath)

        
        let row = indexPath.row
        // Configure the cell...
        
       // let s = "\(row)"
        let p = self.products![row]
        cell.textLabel!.text = "\(p.descr!)  -- \(p.cost!)"
        return cell
    }

    
    @IBAction func AskJson(sender: AnyObject) {
        
        self.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate: self)
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
                let quantity = dict["quantita"] as? NSString
                let c = Product( descr: desc!, cost: cost!.doubleValue, quantity:  quantity!.integerValue)
                print(c)
                products?.append(c)
                
            }
            
            self.tableView.reloadData()
            
        }
        catch
        {
            print ("Json error")
        }
    }    // processJSON
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexpath=self.tableView.indexPathForSelectedRow
        let row = indexpath!.row
        let p = self.products![row]

        
        let detailController = segue.destinationViewController as!ProductDetailController
        detailController.p = p
        
        
        
    }

}
