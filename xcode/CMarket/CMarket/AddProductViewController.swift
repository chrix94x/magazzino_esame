//
//  AddProductViewController.swift
//  CMarket
//
//  Created by christian scorza on 31/05/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit



class AddProductViewController: UIViewController, DataParserDelegate{

    
    @IBOutlet weak var descriptionTextfield: UITextField!
    
    @IBOutlet weak var quantityTextfield: UITextField!
    
    @IBOutlet weak var priceTextfield: UITextField!
    
    @IBOutlet weak var barcodeTextfield: UITextField!
    
    
    
    @IBAction func buttonAddProduct(sender: AnyObject) {
        
        let descr = descriptionTextfield.text
        let quantity = quantityTextfield.text
        let price = priceTextfield.text
        let barcode = barcodeTextfield.text
        
        // let sum = descr!+quantity!+price!+barcode!
        
     //   print(sum)
        
    
        enableWheel()
        self.disabletabBar()
    
        if checkFields(descr!, quantity: quantity!, price: price!, barcode: barcode!)
        {
            self.sendCommandAddProduct(descr!,quantity: quantity!,price: price!,barcode: barcode!)
        }
        
        
        disableWheel()
        self.enabletabBar()
    }
    
    
    func checkFields(
        let descr: String,
        let quantity: String,
        let price: String,
        let barcode: String) -> Bool
    {
        
        
        if(descr == "" || quantity == "" || price == "" || barcode == "")
        {
            alertMessage("Fill all fields", message: "please fill all requied fields")
            return false
        }
        
        
        if !checkNumber(price)
        {
            self.alertMessage("price is not valid", message: "please try again")
            return false
        }
        
        
    return true
    }
    
    
    
    
    func alertMessage(title:String, message:String)
    {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
        }))
        
         self.presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    
    
    func checkNumber(number : String) -> Bool
    {
        let mFloat = Float(number)
        
        if  (mFloat != nil) {
            return true
        }else {
            return false
        }
     
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    
    
    }
    
    
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    //.     .. riguardare...
    //   gestire errori dal server e controllare i campi se vuoti
    //   (prima di scrivere o alla risposta)

    func sendCommandAddProduct(
        let descr: String,
        let quantity: String,
        let price: String,
        let barcode: String)
    {
        
        
        
        // {"command":"insert","barcode":"664537223323","description":"testfantastico","quantity":"100","price":"302"}
        
        
        let command = "{\"command\":\"insert\",\"barcode\":\"" + barcode + "\",\"description\":\"" + descr + "\",\"quantity\":\"" + quantity + "\",\"price\":\"" + price
        
        let close = "\"}"
        
        let barcodeCommand = command + close + "\n"
        
        
        
        
        print(barcodeCommand)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            TCPStreamer.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
            
            print("sending barcode command")
            TCPStreamer.sharedInstance.writeToServer(barcodeCommand)
        }
    }
    
    
    func parseJSON(data: NSData?)
    {
        
        
        if data == nil{
            return
        }
        
        do {
            
            let resultJson : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
         
            
            let result = resultJson["result"]
            
            let ok : Bool = (result?.boolValue)!
            
           
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
 
    }    // parseJSON

    
    func alertBarcode(returned : Bool)
    {
        
        
        if (returned)
        {
            self.enableWheel()
            self.disabletabBar()
            let alertController = UIAlertController(title: "Added with success",message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
               
                
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.disableWheel()
            self.enabletabBar()
        }
        if(!returned)
        {
            
            self.enableWheel()
            self.disabletabBar()
            let alertController = UIAlertController(title: "Unknow error, try again",message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
               
                
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            self.disableWheel()
            self.enabletabBar()
            
        }
        
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
    
    func disableWheel(){
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))),
                        dispatch_get_main_queue(),
                        {
                            LoadingOverlay.shared.hideOverlayView()
        })
    }
    
    func enabletabBar(){
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))),
                        dispatch_get_main_queue(),
                        {
                            self.tabBarController?.tabBar.hidden = false
        })
    }
    
    func disabletabBar()
    {
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))),
                        dispatch_get_main_queue(),
                        {
                            self.tabBarController?.tabBar.hidden = true  //hide bar
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
    
    


}






