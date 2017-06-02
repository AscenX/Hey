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
    
    @property (nonatomic, assign) BOOL fromMyStatus;


@end

@implementation StatusViewModel

- (instancetype)initWithFromMyStatus:(BOOL)fromMyStatus {
    if (self = [super init]) {
        _fromMyStatus = fromMyStatus;
        _statuses = [NSMutableArray array];
    }
    return self;
}

- (RACCommand *)fetchStatusCommand {
    if (!_fetchStatusCommand) {
        _fetchStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            if (self.fromMyStatus) {
                return [[[StatusManager sharedManager] fetchUserStatuses] doNext:^(id  _Nullable x) {
                    self.statuses = x;
                }];
            }
            else {
                return [[[StatusManager sharedManager] fetchAllStatuses] doNext:^(id  _Nullable x) {
                    self.statuses = x;
                }];
            }
        }];
    }
    return _fetchStatusCommand;
    
}
    
    - (RACCommand *)sendStatusCommand {
        if (!_sendStatusCommand) {
            _sendStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(Status *status) {
                return [[StatusManager sharedManager] sendStatus:status];
            }];
        }
        return _sendStatusCommand;
    }
    
    - (RACCommand *)likeStatusCommand {
        if (!_likeStatusCommand) {
            @weakify(self)
            _likeStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(Status *status) {
                if (self.fromMyStatus) {
                    return [[[StatusManager sharedManager] likeUserStatusId:status.Id like:!status.youLike] doNext:^(id  _Nullable x) {
                        @strongify(self)
                        self.statuses = x;
                    }];
                }
                else {
                    return [[[StatusManager sharedManager] likeStatusId:status.Id like:!status.youLike] doNext:^(id  _Nullable x) {
                        @strongify(self)
                        self.statuses = x;
                    }];
                }
            }];
        }
        return _likeStatusCommand;
    }

- (void)likeStatus:(Status *)status {
    [self.likeStatusCommand execute:status];
}

@end
