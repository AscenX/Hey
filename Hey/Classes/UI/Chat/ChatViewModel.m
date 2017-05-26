//
//  ChatViewModel.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatViewModel.h"
#import "User.h"
#import "Store.h"

@interface ChatViewModel ()

@property (nonatomic, strong, readwrite) User *user;

@end

@implementation ChatViewModel

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _user = user;
        Viewer *viewer = [[Store sharedStore].viewerSignal first];
        User *me = [[Store sharedStore].userSignal first];
        
        //过滤聊天记录
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0; i < viewer.chatRecords.count; ++i) {
            ChatRecord *chatRecord = viewer.chatRecords[i];
            if ((chatRecord.fromUserId.integerValue == user.Id.integerValue &&
                chatRecord.toUserId.integerValue == me.Id.integerValue) ||
                (chatRecord.fromUserId.integerValue == me.Id.integerValue &&
                 chatRecord.toUserId.integerValue == user.Id.integerValue)) {
                    [tmp addObject:chatRecord];
            }
        }
        _chatRecords = [tmp mutableCopy];
    }
    return self;
}

@end
