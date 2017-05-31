//
//  Status.m
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "Status.h"


@implementation Status

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id" : @"StatusId",
             @"userId" : @"UserId",
             @"username" : @"UserName",
             @"avatar" : @"Avatar",
             @"content" : @"Content",
             @"imageURL" : @"ImageURL",
             @"likeNum" : @"LikeNum",
             @"time" : @"CreatedAt",
             @"imageScale" : @"ImageScale",
             @"youLike" : @"YouLike",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userId" : @"user_id",
             @"username" : @"username",
             @"avatar" : @"avatar",
             @"content" : @"content",
             @"imageURL" : @"image_url",
             @"likeNum" : @"like_num",
             @"time" : @"time",
             @"imageScale" : @"image_scale",
             @"youLike" : @"you_like",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_statuses";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}

@end
