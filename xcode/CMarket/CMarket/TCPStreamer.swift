//
//  TCPStreamer.swift
//  CMarket
//
//  Created by christian scorza on 15/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit

class TCPStreamer: NSObject , NSStreamDelegate {
    
    //create singleton single class
    
    static let sharedInstance = TCPStreamer()
    
    
    // PRIVATE VARIABLES 
    
    private var inputStream : NSInputStream?
    private var outputStream : NSOutputStream?
    
    
    override init () {
     super.init()
    }
    
    
    
    final func openSocketsIfNeeded(Host: String, onPort port: UInt32)->Bool
    {

        var readStream : Unmanaged<CFReadStream>?
        var writeStream :  Unmanaged<CFWriteStream>?
    
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault , Host, port, &readStream, &writeStream)
        
        
        if (readStream != nil) && (writeStream != nil  )
         {
            
            
        self.inputStream = readStream! .takeRetainedValue()
        self.outputStream = writeStream! .takeRetainedValue()
           
            inputStream!.delegate = self
            outputStream!.delegate = self

            inputStream!.delegate = self
            outputStream!.delegate = self
            
            inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            
            inputStream!.open()
            outputStream!.open()
            
            return true
        }
        
        return false
    
    }
    

    final func writeToServer(s:String)
    {
        if let c = s.cStringUsingEncoding(NSUTF8StringEncoding)
        {
            let len : Int = Int (strlen(c))
            let p = UnsafePointer<UInt8>(c)
            let written = self.outputStream?.write(p,maxLength:  len)
            
        }
    
    }
    
    
    
    final func closeStreams()
    {
     let loop = NSRunLoop.currentRunLoop()
        
        self.inputStream!.close()
        self.inputStream!.removeFromRunLoop(loop, forMode: NSDefaultRunLoopMode)
        self.inputStream = nil
        
        self.outputStream!.close()
        self.outputStream!.removeFromRunLoop(loop, forMode: NSDefaultRunLoopMode)
        self.outputStream = nil
    
    }

    
    //MARK NS STREAM delegate methods 
    
    private final func processResponse (iStream : NSInputStream)
    {
    
    let MAX_BUF_LEN = 1014
    var buf = [UInt8](count: MAX_BUF_LEN, repeatedValue:0 )
    let data = NSMutableData()
        let len = iStream.read(&buf, maxLength : MAX_BUF_LEN)
        
        
        if(len>0) && (len<MAX_BUF_LEN)
        {
            
            data.appendBytes(&buf, length: len)
            let s = String(data: data, encoding: NSUTF8StringEncoding)
            print(s)
            
            
            //todo
            processJson(data: NSData)
            {
        
            do {
                let json : NSArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSArray
             
                
                for dict in json
                {
                    //TODO da finire la funzione parse json.
                    
                    
                /*
                    
                let id = dict["id"]
                let desc = dict["descrizione"]
                let c = product(id: id, desc: dict)
                    
                    
                */
                    
                }
                if let dictionary = object as? [String: AnyObject] {
                        readJSONObject(dictionary)
                    }
                } catch {
                    print ("Json error")
                }
            
            
            }
        }
            
        else
        {
            NSLog("no data. /too data")
        }
        
        
    }
    
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
     switch(eventCode)
     {
     case NSStreamEvent.OpenCompleted:
        
        
        break
        
     case NSStreamEvent.HasSpaceAvailable:
        
        break
        
     case NSStreamEvent.HasBytesAvailable:
        //TODO or better to compare with === to inputStream? 
        if let iStream = aStream as? NSInputStream
        {
            processResponse(iStream)
            
            //TODO i do close but not correct....
            
            self.closeStreams()
            
        }
        
     default:
        
        break
        
        
        }
    }
    
    
}
