//
//  User.m
//  VideoCoreTest
//
//  Created by Turtleeeeeeeeee on 15/10/12.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "User.h"

@implementation User

static User *_user = nil;

+ (User *)sharedUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[super allocWithZone:NULL] init];
    });
    return _user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [User sharedUser];
}

@end
