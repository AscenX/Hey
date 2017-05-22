//
//  SIMPUser.m
//  Hey
//
//  Created by Ascen on 2017/3/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SIMPUser.h"
#import "SIMPMessage.h"
#import "SIMPConnection.h"
#import "SIMPConstants.h"
@import Protobuf;

@interface SIMPUser ()


@property (nonatomic, strong) SIMPConnection *connection;

@end

@implementation SIMPUser

- (instancetype)initWithUserID:(NSString *)userID {
    if (self = [super init]) {
        _userID = userID;
//        _connection = [[SIMPConnection alloc] initWithRemoteHost:@"192.168.1.132" port:8081 forUser:userID];
    }
    return self;
}

- (void)sendMessage:(SIMPMessage *)msg{
    Message *message = msg.message;
    if (msg.type == SIMPMessageTypeConnect) {
        [self.connection sendData:message.data tag:1];
    } else if (msg.type == SIMPMessageTypeText ||
        msg.type == SIMPMessageTypeImage ||
        msg.type == SIMPMessageTypeAudio) {
        [self.connection sendData:message.data tag:2];
    } 
}



@end
