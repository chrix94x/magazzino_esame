//
//  TCPStreamer.swift
//  CMarket
//
//  Created by christian scorza on 15/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

import UIKit

class TCPStreamer: NSObject, NSStreamDelegate {
    
    //create singleton single class
    
    static let sharedInstance = TCPStreamer()
    
    
    // PRIVATE VARIABLES
    
    private var inputStream : NSInputStream?
    private var outputStream : NSOutputStream?
    private var data : NSMutableData?
    
    private var delegate: DataParserDelegate?
    
    
    override init () {
        super.init()
    }
    
    
    
    final func openSocketsIfNeeded(Host: String, onPort port: UInt32, delegate: DataParserDelegate)->Bool
    {
        self.delegate = delegate
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
    
    
    final func writeToServer(s:String)->Bool
    {
        self.outputStream?.streamStatus
       
        
        
        if let c = s.cStringUsingEncoding(NSUTF8StringEncoding)
        {
            let len : Int = Int (strlen(c))
            let p = UnsafePointer<UInt8>(c)
            let written = self.outputStream?.write(p,maxLength:  len)
            
            print (written!)

            
            
            if written > 0
            {
               return true
            }
        }
        return false
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
        
        self.data = nil
    }
    
    
    //MARK NS STREAM delegate methods
    
    private final func processResponse (iStream : NSInputStream)
    {
        let MAX_BUF_LEN = 1014*2
        var buf = [UInt8](count: MAX_BUF_LEN, repeatedValue:0 )
        let len = iStream.read(&buf, maxLength : MAX_BUF_LEN)
        if(len>0) && (len<MAX_BUF_LEN) {
            
            // lazy loading of buffer:
            if self.data == nil{
                self.data = NSMutableData() // allocate buffer.
            }
            
            data!.appendBytes(&buf, length: len)
            //if let s = String(data: data!, encoding: NSUTF8StringEncoding){
            //    print(s)
            //}
            
        }
        else if len == 0 {
            // print("no data")
        }
        else
        {
            print("too many data")
        }
    }
    
    
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        // print(eventCode)
        
        switch(eventCode)
        {
        case NSStreamEvent.OpenCompleted:
            
            break
            
        case NSStreamEvent.HasSpaceAvailable:
            
            break
            
        case NSStreamEvent.HasBytesAvailable:
            //TODO or better to compare with === to inputStream?
            if let iStream = aStream as? NSInputStream {
                processResponse(iStream)
            }
            
        case NSStreamEvent.EndEncountered:
            
            self.delegate?.parseJSON(self.data)
            self.closeStreams() // will also release buffer.
            
            break
        default:
            
            break
            
            
        }
    }


    
}


