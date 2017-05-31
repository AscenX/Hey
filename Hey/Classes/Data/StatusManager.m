//
//  StatusManager.m
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "StatusManager.h"
#import "Store.h"
#import "RestClient+Status.h"
#import "User.h"

@implementation StatusManager

+ (instancetype)sharedManager
{
    static StatusManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (RACSignal *)fetchAllStatuses {
    User *user = [[Store sharedStore].userSignal first];
    return [[RestClient sharedClient] statusByUserId:user.Id];
}

- (RACSignal *)sendStatus:(Status *)status {
    User *user = [[Store sharedStore].userSignal first];
    return [[RestClient sharedClient] sendStatus:status withUserId:user.Id];
}
    
- (RACSignal *)likeStatusId:(NSNumber *)statusId like:(BOOL)like {
    User *user = [[Store sharedStore].userSignal first];
    return [[RestClient sharedClient] likeStatus:statusId like:like];
}

@end
