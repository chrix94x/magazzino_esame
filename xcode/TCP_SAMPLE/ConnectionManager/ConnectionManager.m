//
//  ConnectionManager.m
//  TCP_SAMPLE
//
//  Created by christian scorza on 06/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import "ConnectionManager.h"


@interface ConnectionManager() <NSStreamDelegate>
@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;
@end




@implementation ConnectionManager




//#define HOST @"172.16.10.98"
#define HOST @"localhost"
//#define HOST @"192.168.2.5"
//#define HOST @"104.106.82.112"	// apple
//#define HOST @"77.93.255.134"
#define PORT 2000


static ConnectionManager* _sharedInstance = nil;


static uint8_t buffer[1024 * 128];
static NSInteger totalBufferLen = 0;



+(ConnectionManager*)sharedInstance;
{
    if (_sharedInstance == nil){
        _sharedInstance = [[ConnectionManager alloc]init];
    }
    return _sharedInstance;
    
}





- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)HOST, PORT, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate: self];
    [self.outputStream setDelegate: self];
    
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
    
    buffer[0] = 0; // clear buffer.
    totalBufferLen = 0; // reset index.
}


-(void)closeStreams;
{
    NSRunLoop * loop = [NSRunLoop currentRunLoop];
    
    if (self.inputStream != nil){
        
        [self.inputStream close];
        [self.inputStream removeFromRunLoop:loop forMode:NSDefaultRunLoopMode];
        self.inputStream = nil;
    }
    
    if (self.outputStream != nil){
        [self.outputStream close];
        [self.outputStream removeFromRunLoop: loop forMode:NSDefaultRunLoopMode];
        self.outputStream = nil;
    }
    
}


-(void)closeAllSocketsOnMainThread
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self closeStreams];
        
    });
    
}





- (void)sendCommand:(NSString*)cmd withDelegate:(id<ConnectionManagerDelegate>) delegate;

{
    self.delegate = delegate;
    
    NSData *data = [[NSData alloc] initWithData:[cmd dataUsingEncoding:NSASCIIStringEncoding]];
    
    [self closeStreams];
    [self initNetworkCommunication];
    
    NSInteger written = [self.outputStream write:[data bytes] maxLength:[data length]];
    
    printf("written %d", (int)written);
}






- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    // NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == self.inputStream){
                [self processResponse];
            }
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            [self parseBuffer];
            [self closeAllSocketsOnMainThread];
            break;
            
        default:
            //NSLog(@"Unknown event");
            break;
    }
}


-(void)processResponse{
    
    NSInteger len;
    
    if ([self.inputStream hasBytesAvailable])
    {
        
        uint8_t * bufferPtr = buffer + totalBufferLen;
        len = [self.inputStream read:bufferPtr maxLength:sizeof(buffer) - totalBufferLen];
        if(len>0) {
            
            totalBufferLen += len;
            
            // to debug add a zero:
            bufferPtr[totalBufferLen] = 0;
            NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
            if (nil != output) {
                // NSLog(@"server said: %@", output);
                NSLog(@"\npartial: \n%@", output);
            }
        }
    }
}



-(void)parseBuffer{
    NSLog(@"\n=============\nALL: \n%s", buffer);
    if (self.delegate)
    {
        NSString * s = [[NSString alloc]initWithBytes:buffer length:totalBufferLen encoding: NSUTF8StringEncoding];
        [self.delegate processJSONString:s];
    }
}


@end
