//
//  ProductsTableViewController.swift
//  CMarket
//
//  Created by christian scorza on 08/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//




//SCRITTO TUTTO DA NOI !!!!!! 




import UIKit



// let host = "localhost"
let host="192.168.1.7"
//let host="172.16.10.115"


let port : UInt32 = 2000




class ProductsTableViewController: UITableViewController, DataParserDelegate{

    var products:  [Product]?
    
    private var timeoutTimer: NSTimer?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTimeOutTimer()
        loadDataFromServer()
    }

    
    final func startTimeOutTimer(){
        self.timeoutTimer = NSTimer(timeInterval: 5,
                                    target: self,
                                    selector: #selector(TCPStreamer.timeOutOccurred),
                                    userInfo: nil,
                                    repeats: false)
        NSRunLoop.currentRunLoop().addTimer(self.timeoutTimer!, forMode: NSRunLoopCommonModes)
    }

    
    
    
    func timeOutOccurred() {
        print("timeOutOccurred")
    }
    

    func loadDataFromServer_FAKE(){
        
        products = [Product]()
        
    }
    
    func loadDataFromServer(){
 
        products = [Product]()
        
        TCPStreamer.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
        
        
        let ok = sendCommand("list")
       
        if !ok
        {
            self.alertControllerConnectionError()
        }
        
    }
    
    func alertControllerConnectionError()
    {
        let alertController = UIAlertController(title: "connection error", message: "impossible server connection ", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    
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
        cell.textLabel!.text = "\(p.descr!)"
        //-- \(p.cost!)"
        return cell
    }

  
   
    
    func sendCommand( inputCmd: String) ->Bool  {
        
        let command = "{\"command\":"
        let close = "}"
        let cmd = command + "\"" + inputCmd + "\"" + close + "\n"
        print(cmd)
        
        
        //last
        let ok = TCPStreamer.sharedInstance.writeToServer(cmd)
        return ok
    }
    
    
    
       
    func parseJSON(data: NSData?){
        if data == nil{
            print("NO CONNECTION")
            return
        }
        
        do {
            let json : NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSArray
            
            for dict in json {
                
                // print(dict)
                // let id = dict["id"] as? String
                let desc = dict["descrizione"] as? String
                let cost = dict["prezzo"] as? NSNumber
                let quantity = dict["quantita"] as? NSString
                let barcode = dict["barcode"] as? String
                
                let c = Product( descr: desc!, cost: cost!.doubleValue, quantity:  quantity!.integerValue ,barcode: barcode!)
                print(c)
                products?.append(c)
                
            }
            
            self.tableView.reloadData()
            
        }
        catch
        {
            print ("Json error")
        }
    }    // parseJSON
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexpath=self.tableView.indexPathForSelectedRow
        let row = indexpath!.row
        let p = self.products![row]

        
        let detailController = segue.destinationViewController as!ProductDetailController
        detailController.p = p
        
        
        
    }
    
    /*
    func generateBarcodeFromString(string: String) -> UIImage? {
        
        let data = string.dataUsingEncoding(NSASCIIStringEncoding)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransformMakeScale(3, 3)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
        
        
    }
    
    
    let image = generateBarcodeFromString("Hacking with Swift")
*/
}
