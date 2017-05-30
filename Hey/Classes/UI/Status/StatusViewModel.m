//
//  StatusViewModel.m
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "StatusViewModel.h"
#import "StatusManager.h"

@interface StatusViewModel ()

@property (nonatomic, copy, readwrite) NSMutableArray *statuses;


@end

@implementation StatusViewModel

- (instancetype)init {
    if (self = [super init]) {
        _statuses = [NSMutableArray array];
    }
    return self;
}

- (RACCommand *)fetchStatusCommand {
    if (!_fetchStatusCommand) {
        _fetchStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[[StatusManager sharedManager] fetchAllStatuses] doNext:^(id  _Nullable x) {
                self.statuses = x;
            }];
        }];
    }
    return _fetchStatusCommand;
    
}

- (void)sendStatus:(Status *)status {
    [[[StatusManager sharedManager] sendStatus:status] subscribeNext:^(id  _Nullable x) {
        if (x) {
//            [self.statuses addObject:x];
        }
    }];
}


@end
