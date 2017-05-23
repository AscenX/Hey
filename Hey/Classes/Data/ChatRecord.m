//
//  ChatRecord.m
//  TestProtobuf
//
//  Created by Ascen on 2017/3/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatRecord.h"

@implementation ChatRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userId" : @"user_id",
             @"text" : @"text",
             @"imageURL" : @"image_url",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userId" : @"user_id",
             @"text" : @"text",
             @"imageURL" : @"image_url",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_chat_records";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}
@end
