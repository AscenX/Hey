//
//  ChatViewModel.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatViewModel.h"
#import "User.h"

@interface ChatViewModel ()

@property (nonatomic, strong, readwrite) User *user;

@end

@implementation ChatViewModel

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _user = user;
        _chatRecords = [NSMutableArray array];
    }
    return self;
}

@end
