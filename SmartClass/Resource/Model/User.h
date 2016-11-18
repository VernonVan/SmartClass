//
//  User.h
//  VideoCoreTest
//
//  Created by Turtleeeeeeeeee on 15/10/12.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User: NSObject

@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *password;

+ (User *)sharedUser;

@end
