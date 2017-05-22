//
//  HomeViewModel.m
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "HomeViewModel.h"
#import "ChatSession.h"

@interface HomeViewModel ()

@property (nonatomic, strong, readwrite) NSMutableArray<ChatSession *> *sessions;


@end

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        _sessions = [self getSessions];
    }
    return self;
}

- (NSMutableArray *)getSessions {
//    [self.realm beginWriteTransaction];
//    RLMResults *res = [ChatSession allObjects];
//    [self.realm commitWriteTransaction];
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < res.count; ++i) {
//        ChatSession *s = [res objectAtIndex:i];
//        [arr addObject:s];
//    }
//    return arr;
    return nil;
}


- (void)updateSessions {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self.realm beginWriteTransaction];
//        [self.realm addOrUpdateObjectsFromArray:self.sessions];
//        [self.realm commitWriteTransaction];
//    });
}

@end
