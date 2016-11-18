//
//  SelectResolutionTableViewDataSource.h
//  VideoCoreTest
//
//  Created by Turtleeeeeeeeee on 15/11/17.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^configureCell)(UITableViewCell *, NSString *);

@interface SelectResolutionTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) NSArray *resolutionDatasource;
@property (nonatomic, strong) configureCell configureCellBlock;

@end
