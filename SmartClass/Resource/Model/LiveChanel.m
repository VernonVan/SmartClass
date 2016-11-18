//
//  Livechannel.m
//  VideoCoreTest
//
//  Created by Turtleeeeeeeeee on 15/8/16.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "LiveChanel.h"

@implementation LiveChannel

- (id)initWithURL:(NSString *)url andStreamKey:(LiveStreamKey *)streamKey{
    self = [super init];
    if (self) {
        _url = url;
        _rawStreamKey = streamKey;
        _rawStreamKey.delegate = self;
    }
    return self;
}

- (void)updateGeneratedStreamKey {
    _streamKey = [NSString stringWithFormat:@"%@_%@",_rawStreamKey.userName, _rawStreamKey.date];
}

@end
