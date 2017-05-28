//
//  ChatRecord.h
//  TestProtobuf
//
//  Created by Ascen on 2017/3/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@class SIMPMessage;

typedef NS_ENUM(NSUInteger, ChatRecordType) {
    ChatRecordTypeText,
    ChatRecordTypeImage,
    ChatRecordTypeAudio,
};

@interface ChatRecord : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

- (instancetype)initWithSIMPMessage:(SIMPMessage *)message;

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, copy) NSString *type;
//@property (nonatomic, assign) ChatRecordType chatRecordType;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSNumber *fromUserId;
@property (nonatomic, strong) NSNumber *toUserId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) NSNumber *imageScale;

@end
