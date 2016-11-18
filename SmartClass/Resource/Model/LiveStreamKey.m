
//
//  LiveStreamKey.m
//  VideoCoreTest
//
//  Created by turtle on 15/10/23.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "LiveStreamKey.h"

@implementation LiveStreamKey

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    [_delegate updateGeneratedStreamKey];
}

- (void)setChannel:(NSString *)channel {
    _channel = channel;
    [_delegate updateGeneratedStreamKey];
}

- (void)setResolution:(NSString *)resolution {
    _resolution = resolution;
    [_delegate updateGeneratedStreamKey];
}

- (void)setDate:(NSString *)date {
    _date = date;
    [_delegate updateGeneratedStreamKey];
}

@end
