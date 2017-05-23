//
//  ProfileViewModel.m
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ProfileViewModel.h"
#import "Store.h"

@implementation ProfileViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray *)infos {
    return @[
            @[@{
                    @"icon" : @"icon_profile_status",
                    @"title" : @"动态",
                 },
//                @{
//                    @"icon" : @"stan",
//                    @"title" : @"",
//                 },
              ],
            @[
                @{
                     @"icon" : @"icon_setting",
                     @"title" : @"设置",
                     },
                @{
                    @"icon" : @"icon_about",
                    @"title" : @"关于",
                    },

                ],
            @[
                @{
                    @"icon" : @"icon_logout",
                    @"title" : @"退出",
                    },
                ]
            ];
}

- (RACCommand *)logoutCommand {
    if (!_logoutCommand) {
        _logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[Store sharedStore] clearViewer];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _logoutCommand;
}

@end
