//
//  BarcodeViewController.swift
//  CMarket
//
//  Created by christian scorza on 02/05/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,DataParserDelegate
{
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    let sharedInstance = TCPStreamer.sharedInstance
    private var data : NSMutableData?
    
    
    
    
    
   
    override func viewDidLoad() {
       
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.blackColor()
            captureSession = AVCaptureSession()
            
            let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                 failed();
                return;
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
            } else {
                failed()
                return
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
            previewLayer.frame = view.layer.bounds;
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            view.layer.addSublayer(previewLayer);
            
            captureSession.startRunning();
        
        
        }

    

    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
       
}
    
    func alertBarcodeSuccessful(code: String)
    {
        
        
        let alertController = UIAlertController(title: "Barcode message", message: "barcode successuful ", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            //barcode not correct so... i recall viewDidLoad
            
            self.viewDidLoad()

            }))
        
        alertController.addAction(UIAlertAction(title: "remove product", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in

            self.AlertRemovedSuccessOrNot(code)
          

        }))
        
        alertController.addAction(UIAlertAction(title: "2nd", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            // codice qui x qualcosa
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func foundCode(code: String) {
        
        print(code) //Print the barcode.
        
       
        dismissViewControllerAnimated(true, completion: nil)
        
        
        
        alertBarcodeSuccessful(code)
        
        
        
    }
    
    

    func AlertRemovedSuccessOrNot(code: String)
{
    
    
    LoadingOverlay.shared.showOverlay(self.view)  //loading wheel
    
    self.tabBarController?.tabBar.hidden = true  //hide bar
    
    self.sendCommandRemove(code)   //send command remove
    
    
    //TODO TODO TODO//TODO TODO TODO//TODO TODO TODO//TODO TODO TODO//TODO TODO TODO//TODO TODO TODO//TODO TODO TODO
    
    //i have to read a message from server or error.. i don't know how.
    
    // read message or error with if
    
    //code todo
    
    
    
    LoadingOverlay.shared.hideOverlayView()    //close wheel
    
    
    //send message success
    
    let messageRemovedSuccess = UIAlertController(title: "Product Message", message: "Removed Success! ", preferredStyle: UIAlertControllerStyle.Alert)
    
    messageRemovedSuccess.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler:{ (action: UIAlertAction!) in
        
        //show bar and view again
        
        self.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
    }))
    self.presentViewController(messageRemovedSuccess, animated: true, completion: nil)
    
    
    
    
    
    //show bar
    //self.tabBarController?.tabBar.hidden = false
    
    //close code
    //close loading
    //LoadingOverlay.shared.hideOverlayView()
    
    
    
    
}

    func sendCommandRemove(let barcode: String)
    {
        
        // {"command":"remove", "barcode":"barcodeSended"}
        
        let command = "{\"command\":\"remove\",\"barcode\":\""
        let close = "\"}"
        
        let barcodeCommand = command + barcode + close
    
        print(barcodeCommand)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
            
            print("sending barcode command")
            
            self.sharedInstance.writeToServer(barcodeCommand)
            
            
           self.sharedInstance.closeStreams()
           
        }
        
        
        
        
    }


    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    
    /*
    //TODO
    func parseJSONWithString(data: NSData?)->String{
        
         //TODO
         
        if data == nil{
         return "no data"
         }
         
    do{
         let json : NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSArray
         
         for dict in json {
         
         // print(dict)
         let message = dict["message"] as? String
         let error = dict["error"] as? String
        
            if error != nil
            {
            print(error)
            return error!
            }
            if message != nil
            {
            print (message)
            return message!
            }
        }
   //     self.
            
    }
                catch
                {
                    print ("Json error")
                }
        return "error"
}
    */
    
    func parseJSON(data: NSData?)
    {
        //
    }
    
}

