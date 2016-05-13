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
            private var data : NSMutableData?
            

            override func viewDidLoad() {
                
                super.viewDidLoad()
                /*
                dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))),
                    dispatch_get_main_queue(),
                    {
                        self.foundCode("111111")
                    }
                )
         
                return;
                */
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
            
            
            override func viewWillAppear(animated: Bool) {
                super.viewWillAppear(animated)
                self.startCapturing()
            }
            
            
            
            override func viewWillDisappear(animated: Bool) {
                super.viewWillDisappear(animated)
                
                self.stopCapturing();
            }
            
            
            
            final func stopCapturing(){
                
                if (captureSession?.running == true) {
                    captureSession.stopRunning();
                }
            }
            
            
            final func startCapturing(){
                if (captureSession?.running == false) {
                    captureSession.startRunning();
                }
            }
            
            
            
            func failed() {
                let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(ac, animated: true, completion: nil)
                captureSession = nil
            }
            
            
            
            func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
                captureSession.stopRunning()
                
                if let metadataObject = metadataObjects.first {
                    let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
                    
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    foundCode(readableObject.stringValue);
                }
                
            }
            
            func barcodeRecognized(code: String)
            {
                let alertController = UIAlertController(title: "Barcode recognized",
                                                        message: "\"\(code)\"", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    
                    self.startCapturing()
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "Remove product", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    
                    self.startRemovingItemWithCode(code)
                    
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            
            func foundCode(code: String) {
                print(code) //Print the barcode.
                barcodeRecognized(code)
            }
            
            
            
            func startRemovingItemWithCode(code: String) {
                
                enableWheel()  //loading wheel
                
               // self.tabBarController?.tabBar.hidden = true  //hide bar
                
                self.sendCommandRemove(code)   //send command remove
        /*
                
                LoadingOverlay.shared.hideOverlayView()    //close wheel
                
                
                //send message success
                
                let messageRemovedSuccess = UIAlertController(title: "Product Message", message: "Removed Success! ", preferredStyle: UIAlertControllerStyle.Alert)
                
                messageRemovedSuccess.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler:{ (action: UIAlertAction!) in
                    
                    //show bar and view again
                    self.tabBarController?.tabBar.hidden = false
                }))
                self.presentViewController(messageRemovedSuccess, animated: true, completion: nil)
                
                //show bar
                //self.tabBarController?.tabBar.hidden = false
                
                //close code
                //close loading
                //LoadingOverlay.shared.hideOverlayView()
                
                */
            }
            
            
            func sendCommandRemove(let barcode: String)
            {
            
                let command = "{\"command\":\"remove\",\"barcode\":\""
                let close = "\"}"
                
                let barcodeCommand = command + barcode  + close + "\n"
               
                print(barcodeCommand)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    TCPStreamer.sharedInstance.openSocketsIfNeeded(host,onPort: port, delegate:  self)
                    
                    print("sending barcode command")
                    TCPStreamer.sharedInstance.writeToServer(barcodeCommand)
                }
            }
            
            
            override func prefersStatusBarHidden() -> Bool {
                return true
            }
            
            override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
                return .Portrait
            }
            
            
            func parseJSON(data: NSData?)
            {
                
                if data == nil{
                    return
                }
                
                do {
                    //TODO ERROR
                    
                    let s = String.init(data: data!, encoding:NSUTF8StringEncoding)
                    
                    let resultJson : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    print(resultJson)
                    
                    var result = resultJson["result"]
                    
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
            }    // parseJSON
            
            
            
            
            func alertBarcode(returned : Bool)
            {
            
                
            if (returned)
                {
                self.enableWheel()
                self.disabletabBar()
                let alertController = UIAlertController(title: "Removed with success !",message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    self.startCapturing()
                    
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                self.disableWheel()
                self.enabletabBar()
                }
            if(!returned)
            {
                
                self.enableWheel()
                self.disabletabBar()
                let alertController = UIAlertController(title: "barcode not found ! ",message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    self.startCapturing()
                    
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                self.disableWheel()
                self.enabletabBar()
                
                }
                
                
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

