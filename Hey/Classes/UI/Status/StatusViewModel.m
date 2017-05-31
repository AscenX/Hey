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
    
    - (RACCommand *)sendStatusCommand {
        if (!_sendStatusCommand) {
            _sendStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(Status *status) {
                return [[[StatusManager sharedManager] sendStatus:status] doNext:^(id  _Nullable x) {
                    if (x) {
                        //            [self.statuses addObject:x];
                    }
                }];
            }];
        }
        return _sendStatusCommand;
    }
    
    - (RACCommand *)likeStatusCommand {
        if (!_likeStatusCommand) {
            _likeStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(Status *status) {
                return [[StatusManager sharedManager] likeStatusId:status.Id like:!status.youLike];
            }];
        }
        return _likeStatusCommand;
    }



@end
