//
//  LiveStreamKey.h
//  VideoCoreTest
//
//  Created by turtle on 15/10/23.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LiveStreamKeyDelegate

- (void)updateGeneratedStreamKey;

@end

@interface LiveStreamKey : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *resolution;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, weak) id<LiveStreamKeyDelegate> delegate;

@end
