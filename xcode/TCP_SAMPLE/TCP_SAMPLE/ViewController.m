//
//  ViewController.m
//  TCP_SAMPLE
//
//  Created by christian scorza on 12/03/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import "ViewController.h"



//#define HOST @"172.16.14.127"
#define HOST @"localhost"
//#define HOST @"192.168.2.5"
//#define HOST @"104.106.82.112"	// apple
//#define HOST @"77.93.255.134"

#define PORT 2000
//#define PORT 80





@interface ViewController () <NSStreamDelegate>

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;


@end


uint8_t buffer[1024 * 128];
NSInteger totalBufferLen = 0;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self sendSampleText: nil];
    });
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


-(void)closeStreams
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

//send text


- (IBAction)sendSampleText:(UIButton *)sender {
    
    
    NSString *response  = [NSString stringWithFormat:@"{ \"command\": \"list\",  \"description\": \"testOne\",  \"quantity\": \"20\",\"price\":\"10\"}\n\r"];
    
    // NSString *response  = [[NSDate date] description];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    
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
            NSString *output = [[NSString alloc] initWithBytes:bufferPtr length:len encoding:NSASCIIStringEncoding];
            
            //			if (nil != output) {
            //                NSLog(@"\npartial: \n%@", output);
            //            }
        }
    }
}



-(void)parseBuffer{
    NSLog(@"\n=============\nALL: \n%s", buffer);
    
}


@end