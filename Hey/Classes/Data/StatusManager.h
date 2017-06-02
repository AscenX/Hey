//
//  StatusManager.h
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Status.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface StatusManager : NSObject

+ (instancetype)sharedManager;

- (RACSignal *)fetchAllStatuses;
    
- (RACSignal *)fetchUserStatuses;

- (RACSignal *)sendStatus:(Status *)status;
    
- (RACSignal *)likeStatusId:(NSNumber *)statusId like:(BOOL)like;
    
- (RACSignal *)likeUserStatusId:(NSNumber *)statusId like:(BOOL)like;

@end
