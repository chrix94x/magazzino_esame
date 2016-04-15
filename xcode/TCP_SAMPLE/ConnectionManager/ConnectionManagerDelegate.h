//
//  ConnectionManagerDelegate.h
//  TCP_SAMPLE
//
//  Created by christian scorza on 06/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate <NSObject>

-(void)processJSONString:(NSString*)JSONString;

@end
