//
//  ChatRecord.m
//  TestProtobuf
//
//  Created by Ascen on 2017/3/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatRecord.h"
#import "SIMPMessage.h"
#import <DateTools/NSDate+DateTools.h>

@implementation ChatRecord

- (instancetype)initWithSIMPMessage:(SIMPMessage *)message {
    if (self = [super init]) {
        switch (message.type) {
            case SIMPMessageTypeText:
                _type = @"text";
//                _chatRecordType = ChatRecordTypeText;
                break;
            case SIMPMessageTypeImage:
                _type = @"image";
//                _chatRecordType = ChatRecordTypeImage;
                break;
            case SIMPMessageTypeAudio:
                _type = @"audio";
//                _chatRecordType = ChatRecordTypeAudio;
                break;
            default:
                break;
        }
        
        _Id = [NSNumber numberWithUnsignedInteger:message.messageId];
        _content = message.content;
        _fromUserId = [NSNumber numberWithInteger:message.fromUser.integerValue];
        _toUserId = [NSNumber numberWithInteger:message.toUser.integerValue];
        if ([message.time formattedDateWithFormat:@"MM"].integerValue > 10) {
            _time = [message.time formattedDateWithFormat:@"MM月dd日 HH:mm"];
        }
        else {
            _time = [message.time formattedDateWithFormat:@"M月dd日 HH:mm"];
        }
        _imageURL = message.imageURL;
        _imageScale = [NSNumber numberWithFloat:message.imageScale];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"fromUserId" : @"from_user_id",
             @"toUserId" : @"to_user_id",
             @"time" : @"time",
             @"type" : @"type",
             @"content" : @"content",
             @"imageURL" : @"image_url",
             @"imageScale" : @"image_scale",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"fromUserId" : @"from_user_id",
             @"toUserId" : @"to_user_id",
             @"time" : @"time",
             @"type" : @"type",
             @"content" : @"content",
             @"imageURL" : @"image_url",
             @"imageScale" : @"image_scale",
             };
}

//+ (NSValueTransformer *)chatRecordTypeJSONTransformer {
//    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:
//            @{
//              @"text" :  @(ChatRecordTypeText),
//              @"image" : @(ChatRecordTypeImage),
//              @"audio" : @(ChatRecordTypeAudio),
//              }];
//}

+ (NSString *)FMDBTableName {
    return @"t_chat_records";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}
@end
