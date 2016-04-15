//
//  ViewController.m
//  TCP_SAMPLE
//
//  Created by christian scorza on 12/03/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import "ConnectionManager.h"
#import "ConnectionManagerDelegate.h"
#import "ViewController.h"



@interface ViewController ()<ConnectionManagerDelegate>


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		[self sendSampleText: nil];
	});
}



//send text


- (IBAction)sendSampleText:(UIButton *)sender {


	NSString *cmd  = [NSString stringWithFormat:@"{ \"command\": \"list\",  \"description\": \"testOne\",  \"quantity\": \"20\",\"price\":\"10\"}\r\n"];
    
    [[ConnectionManager sharedInstance] sendCommand: cmd withDelegate: self];
}



#pragma mark delegate

-(void)processJSONString:(NSString*)JSONString;
{
    
}



@end
