//
//  ShowAllController.m
//  CMarket
//
//  Created by christian scorza on 06/04/16.
//  Copyright © 2016 christian scorza. All rights reserved.
//

#import "ShowAllController.h"

@interface ShowAllController ()

@property NSMutableArray * items;



@end

@implementation ShowAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.items == nil)
        return 0;
    
    NSInteger count = self.items.count;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCellID" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}


@end
