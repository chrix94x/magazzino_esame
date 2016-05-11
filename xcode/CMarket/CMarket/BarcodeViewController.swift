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
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
        alertBarcodeSuccessful()
        
        
        //alert "success" or "not"
        
        
        
        //riavvia schermata
       // viewDidLoad()
        
        
    }
    
    func alertBarcodeSuccessful()
    {
        
        
        let alertController = UIAlertController(title: "Barcode message", message: "barcode successuful ", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "continue", style: UIAlertActionStyle.Default,handler: nil))


        alertController.addAction(UIAlertAction(title: "1st", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
          

           
            //loading wheel 
            
                LoadingOverlay.shared.showOverlay(self.view)
            //start code while loading 
            
            
            //hide bar
            
                self.tabBarController?.tabBar.hidden = true
            
            
            //show bar
            //self.tabBarController?.tabBar.hidden = false
            
            //close code
            //close loading
            //LoadingOverlay.shared.hideOverlayView()

        }))
        
        alertController.addAction(UIAlertAction(title: "2nd", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            // codice qui x remove
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func foundCode(code: String) {
        
        print(code) //Print the barcode.
        
        sendCommandRemove(code)
        
        // riavvia schermata
        
        //popUpUIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
        
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
    
    
    
    
    func parseJSON(data: NSData?){
        
    }

}


