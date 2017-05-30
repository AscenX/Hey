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

- (RACSignal *)sendStatus:(Status *)status;


@end
