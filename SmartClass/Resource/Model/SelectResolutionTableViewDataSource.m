//
//  SelectResolutionTableViewDataSource.m
//  VideoCoreTest
//
//  Created by Turtleeeeeeeeee on 15/11/17.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "SelectResolutionTableViewDataSource.h"

@implementation SelectResolutionTableViewDataSource

- (instancetype)init {
    if (self = [super init]) {
        _resolutionDatasource = @[@"高清", @"普清"];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resolutionDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SelectResolutionTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    _configureCellBlock(cell, _resolutionDatasource[indexPath.row]);
    return cell;
}

@end
