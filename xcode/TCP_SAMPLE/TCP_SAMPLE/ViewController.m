//
//  ViewController.m
//  TCP_SAMPLE
//
//  Created by christian scorza on 12/03/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import "ViewController.h"


#define HOST @"localhost"
#define PORT 2000

@interface ViewController () <NSStreamDelegate>

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	
	[self initNetworkCommunication];
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
	
	// TODO: close when exiting...
	
}

- (IBAction)sendSampleText:(UIButton *)sender {
	
	NSString *response  = [NSString stringWithFormat:@"iam:%@", [NSDate date]];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[self.outputStream write:[data bytes] maxLength:[data length]];
 
}



- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	// NSLog(@"stream event %lu", (unsigned long)streamEvent);
	
	
	switch (streamEvent) {
			
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
			
		case NSStreamEventHasBytesAvailable:
			
			if (theStream == self.inputStream)
			{
				
				uint8_t buffer[1024];
				NSInteger len;
				
				while ([self.inputStream hasBytesAvailable]) {
					len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (nil != output) {
							NSLog(@"server said: %@", output);
						}
					}
				}
			}
			
			break;
			
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
			
		case NSStreamEventEndEncountered:
			break;
			
		default:
			NSLog(@"Unknown event");
	}
}



@end
