//
//  ProductDetailController.swift
//  CMarket
//
//  Created by christian scorza on 24/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit

class ProductDetailController: UIViewController ,DataParserDelegate{


    
    var p : Product?
    
    @IBOutlet weak var LabelDescriptionProduct: UILabel!
    @IBOutlet weak var LabelPriceProduct: UILabel!
    @IBOutlet weak var LabelQuantityProduct: UILabel!
    @IBOutlet weak var LabelBarcodeProduct: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelDescriptionProduct.text = p?.descr
        LabelPriceProduct.text = "\(p!.cost!)"
        LabelQuantityProduct.text = "\(p!.quantity!)"
        LabelBarcodeProduct.text = "\(p!.barcode!)"
        
        self.title = "Details" + "  \(p!.descr!)"
        
    }
 
    @IBAction func deleteButton(sender: AnyObject) {
        
       
       self.alertConfirm()
        
        
        
    }
    
    func alertConfirm()
    {
    
        
        let alertController = UIAlertController(title: "Removing product",
                                                message: "are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            
            self.sendCommandDelete(self.LabelBarcodeProduct.text!,descr: self.LabelDescriptionProduct.text!)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    
    }
 
    
    func sendCommandDelete(let barcode: String,let descr :String)
    {
        
        let command = "{\"command\":\"delete\",\"barcode\":\"" + barcode + "\",\"description\":\"" + descr
        
        let close = "\"}"
        
        let barcodeCommand = command +  close + "\n"
        
        
        print(barcodeCommand)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            TCPStreamer.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
            
            print("sending barcode command")
            TCPStreamer.sharedInstance.writeToServer(barcodeCommand)
        }
    }
    
    
    func parseJSON(data: NSData?){
    
        if data == nil{
            return
        }
        
        do {
            //TODO ERROR
            
            // String.init(data: data!, encoding:NSUTF8StringEncoding)
            
            let resultJson : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            print(resultJson)
            
            let result = resultJson["result"]
            
            let ok : Bool = (result?.boolValue)!
            
            print(ok)
            if ok
            {
                alertBarcode(true)
                
            }
            if !ok
            {
                alertBarcode(false)
            }
        }
        catch
        {
            print ("Json error")
        }

    
}

    
    
    func alertBarcode(returned : Bool)
    {
        
        
        if (returned)
        {
            self.enableWheel()
           
            alertMessage("Removed with success", message: "")
            self.disableWheel()
           
        }
        if(!returned)
        {
            
            self.enableWheel()
           
           self.alertMessage("Unknow error", message: "")
            
            self.disableWheel()
           
            
        }
        
        
    }
    
    
    func disableWheel(){
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))),
                        dispatch_get_main_queue(),
                        {
                            LoadingOverlay.shared.hideOverlayView()
        })
    }
    
    
    
    func enableWheel()
    {
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))),
                        dispatch_get_main_queue(),
                        {
                            LoadingOverlay.shared.showOverlay(self.view)
        })
        
    }
    
    
    
    
    func alertMessage(title:String, message:String)
    {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    

    

  
  
}
