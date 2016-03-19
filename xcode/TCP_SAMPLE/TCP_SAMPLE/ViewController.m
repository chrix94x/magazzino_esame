//
//  ViewController.m
//  TCP_SAMPLE
//
//  Created by christian scorza on 12/03/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import "ViewController.h"



//<<<<<<< HEAD
//#define HOST @"localhost"
//=======
//#define HOST @"localhost"
//>>>>>>> 7f34c4f8c0231a63153e573152b88b325bdd676d
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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // [self initNetworkCommunication];
	
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
	
}


-(void)closeAllSockets
{
	if (self.inputStream != nil){
		
		[self.inputStream close];
		[self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.inputStream = nil;
	}
	
	if (self.outputStream != nil){
		[self.outputStream close];
		[self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		self.outputStream = nil;
	}

}


-(void)closeAllSocketsOnMainThread
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[self closeAllSockets];
		
	});
	
}

//send text


- (IBAction)sendSampleText:(UIButton *)sender {


	NSString *response  = [NSString stringWithFormat:@"{ \"command\": \"list\",  \"description\": \"testOne\",  \"quantity\": \"20\",\"price\":\"10\"}\r\n"];
//    NSString *response = [NSString stringWithFormat:@"ciaomamma guarda"];

	// NSString *response  = [[NSDate date] description];
	
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	
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
            
            if (theStream == self.inputStream)
                [self processResponse];
            
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
			[self closeAllSocketsOnMainThread];
            break;
            
      // default:
        //   NSLog(@"Unknown event");
    }
}


-(void)processResponse{
	
	uint8_t buffer[1024 * 128];
	NSInteger len;
	
	while ([self.inputStream hasBytesAvailable])
	{
		len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
		if (len > 0) {
			
			NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
			
			if (nil != output) {
				// NSLog(@"server said: %@", output);
				NSLog(@"\n%@", output);
              

			}
		}
	}
	
		[self closeAllSocketsOnMainThread];
		
}




@end
