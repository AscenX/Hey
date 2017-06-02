//
//  StatusViewModel.h
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@class Status;

@interface StatusViewModel : NSObject
    
    - (instancetype)initWithFromMyStatus:(BOOL)fromMyStatus;

@property (nonatomic, copy, readonly) NSMutableArray *statuses;

@property (nonatomic, strong) RACCommand *fetchStatusCommand;

@property (nonatomic, strong) RACCommand *sendStatusCommand;
@property (nonatomic, strong) RACCommand *likeStatusCommand;
    
- (void)likeStatus:(Status *)status;


@end
