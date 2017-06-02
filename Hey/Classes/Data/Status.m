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
    
//+ (NSValueTransformer *)timeJSONTransformer {
//    return [NSValueTransformer mtl_dateTransformerWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'" calendar:nil locale:[NSLocale systemLocale] timeZone:[NSTimeZone timeZoneWithName:@"UTC"] defaultDate:nil];
//}
- (NSString *)time {
    return [NSString stringWithFormat:@"%@ %@",[_time substringToIndex:10], [_time substringWithRange:NSMakeRange(11, 8)]];
}


+ (NSString *)FMDBTableName {
    return @"t_statuses";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}

@end
