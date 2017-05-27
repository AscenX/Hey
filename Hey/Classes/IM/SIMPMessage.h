//
//  SIMPMessage.h
//  Hey
//
//  Created by Ascen on 2017/3/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.pbobjc.h"

typedef NS_ENUM(NSUInteger, SIMPMessageType) {
    SIMPMessageTypeText = 1 << 0,
    SIMPMessageTypeImage,
    SIMPMessageTypeAudio,
    SIMPMessageTypeConnect,
    SIMPMessageTypeReceipt,
};

@interface SIMPMessage : NSObject

@property (nonatomic, assign) SIMPMessageType type;
@property (nonatomic, assign) float version;
@property (nonatomic, assign) int64_t messageId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *fromUser;
@property (nonatomic, copy) NSString *toUser;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, assign) float imageScale;
@property (nonatomic, strong, readonly) Message *message;

- (instancetype)initWithType:(SIMPMessageType)type;
- (instancetype)initWithMessage:(Message *)message;

@end
