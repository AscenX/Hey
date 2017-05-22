//
//  Contact.m
//  Hey
//
//  Created by Ascen on 2017/5/21.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id" : @"UserId",
             @"name" : @"UserName",
             @"avatar" : @"Avatar",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"name" : @"name",
             @"avatar" : @"avatar",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_contacts";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}


@end
