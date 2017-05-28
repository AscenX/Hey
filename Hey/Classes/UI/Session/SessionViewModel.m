//
//  HomeViewModel.m
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SessionViewModel.h"
#import "ChatSession.h"
#import "Store.h"

@interface SessionViewModel ()



@end

@implementation SessionViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray *)sessions {
    Viewer *viewer = [[Store sharedStore].viewerSignal first];
    return viewer.chatSessions;
}


- (void)updateSessions {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.realm beginWriteTransaction];
//        [self.realm addOrUpdateObjectsFromArray:self.sessions];
//        [self.realm commitWriteTransaction];
//    });
}

@end
