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
             @"Id" : @"Id",
             @"name" : @"UserName",
             @"iconURL" : @"IconURL",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"id",
             @"name" : @"username",
             @"iconURL" : @"icon_url",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_contacts";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"id"];
}


@end
