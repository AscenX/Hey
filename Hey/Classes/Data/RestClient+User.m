//
//  RestClient+User.m
//  Hey
//
//  Created by Ascen on 2017/4/21.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "RestClient+User.h"
#import "Contact.h"


@implementation RestClient (User)

- (RACSignal *)loginWithUserId:(NSString *)userId password:(NSString *)password {
    NSString *path = @"accesstoken";
    NSDictionary *param = @{
                            @"userId" : userId,
                            @"password" : password,
                            };
    return [self post:path param:param];
}

- (RACSignal *)contactsWithUserId:(NSString *)userId {
    NSString *path = @"contacts";
    NSDictionary *param = @{
                            @"userId" : userId,
                            };
    return [[self get:path param:param] tryMap:^id _Nonnull(id  _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        return [MTLJSONAdapter modelOfClass:[Contact class] fromJSONDictionary:[value objectForKey:@"contacts"] error:errorPtr];
    }];
}

@end
