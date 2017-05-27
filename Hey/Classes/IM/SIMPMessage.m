//
//  SIMPMessage.m
//  Hey
//
//  Created by Ascen on 2017/3/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SIMPMessage.h"
#import "SIMPConstants.h"
#import "Message.pbobjc.h"

@implementation SIMPMessage

- (instancetype)initWithMessage:(Message *)message {
    if (self = [super init]) {
        _message = message;
        _fromUser = message.fromUser;
        _toUser = message.toUser;
        _messageId = message.messageId;
        _content = message.content;
        _imageURL = message.imageURL;
        _imageScale = message.imageScale;
        _time = [NSDate dateWithTimeIntervalSince1970:message.time];
        switch (message.type) {
            case Message_MessageType_Text:
                _type = SIMPMessageTypeText;
                break;
            case Message_MessageType_Image:
                _type = SIMPMessageTypeImage;
                break;
            case Message_MessageType_Audio:
                _type = SIMPMessageTypeAudio;
                break;
            case Message_MessageType_Connect:
                _type = SIMPMessageTypeConnect;
                break;
            case Message_MessageType_Receipt:
                _type = SIMPMessageTypeReceipt;
                break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithType:(SIMPMessageType)type {
    if (self = [super init]) {
        _message = [[Message alloc] init];
        _message.version = SIMPVersion;
        switch (type) {
            case SIMPMessageTypeText:
                _message.type = Message_MessageType_Text;
                _type = SIMPMessageTypeText;
                break;
            case SIMPMessageTypeImage:
                _message.type = Message_MessageType_Image;
                _type = SIMPMessageTypeImage;
                break;
            case SIMPMessageTypeAudio:
                _message.type = Message_MessageType_Audio;
                _type = SIMPMessageTypeAudio;
                break;
            case SIMPMessageTypeConnect:
                _message.type = Message_MessageType_Connect;
                _type = SIMPMessageTypeConnect;
                break;
            case SIMPMessageTypeReceipt:
                _message.type = Message_MessageType_Receipt;
                _type = SIMPMessageTypeReceipt;
                break;
            default:
                break;
        }
    }
    return  self;
}

- (float)version {
    return SIMPVersion;
}

- (void)setMessageId:(int64_t)messageId {
    _messageId = messageId;
    _message.messageId = messageId;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _message.content = content;
}

- (void)setTime:(NSDate *)time {
    _time = time;
    _message.time = [time timeIntervalSince1970];
}

- (void)setFromUser:(NSString *)fromUser {
    _fromUser = fromUser;
    _message.fromUser = fromUser;
}

- (void)setToUser:(NSString *)toUser {
    _toUser = toUser;
    _message.toUser = toUser;
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    _message.imageURL = imageURL;
}

- (void)setImageScale:(float)imageScale {
    _imageScale = imageScale;
    _message.imageScale = imageScale;
}

@end
