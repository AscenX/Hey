//
//  SIMPUser.h
//  Hey
//
//  Created by Ascen on 2017/3/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SIMPConnection.h"

@class SIMPUser;
@class SIMPMessage;

@protocol SIMPUserDelegate <NSObject>
@optional
- (void)user:(SIMPUser *)fromUser didSendMessage:(SIMPMessage *)message toUser:(SIMPUser *)toUser;
- (void)user:(SIMPUser *)fromUser didReceiveData:(SIMPMessage *)message fromUser:(SIMPUser *)fromUser;


@end

@class SIMPMessage;

@interface SIMPUser : NSObject

@property (nonatomic, copy, readonly) NSString *userID;

- (instancetype)initWithUserID:(NSString *)userID;
- (void)sendMessage:(SIMPMessage *)msg;

@end
