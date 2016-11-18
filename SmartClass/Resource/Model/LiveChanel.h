//
//  Livechannel.h
//  VideoCoreTest
//
//  Created by Turtleeeeeeeeee on 15/8/16.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveStreamKey.h"
//rtmp://192.168.4.26/test/
//rtmp://218.19.141.116/live?doPublish=gdoulive     218blablabla
//rtmp://218.19.141.116/otherlive?doPublish=otherlive    fengvk
#define LIVE_URL @"rtmp://218.19.141.116/live?doPublish=gdoulive"

@interface LiveChannel : NSObject <LiveStreamKeyDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *streamKey;
@property (nonatomic, strong) LiveStreamKey *rawStreamKey;

- (id)initWithURL:(NSString *)url andStreamKey:(LiveStreamKey *)streamKey;
- (void)updateGeneratedStreamKey;

@end
