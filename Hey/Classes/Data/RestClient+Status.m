//
//  RestClient+Status.m
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "RestClient+Status.h"

@implementation RestClient (Status)


- (RACSignal *)statusByUserId:(NSNumber *)userId {
    return [[[RestClient sharedClient] get:@"status" param:@{ @"userId" : userId }] tryMap:^id _Nonnull(id  _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        return [MTLJSONAdapter modelsOfClass:[Status class] fromJSONArray:[value objectForKey:@"statuses"] error:errorPtr];
    }];
}

- (RACSignal *)sendStatus:(Status *)status withUserId:(NSNumber *)userId {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"userId" :userId,@"statusId" : status.Id, @"content" : status.content,                                                                           }];
    if (status.imageURL) {
        [param setObject:status.imageURL forKey:@"imageURL"];
        [param setObject:status.imageScale forKey:@"imageScale"];
        
    }
    return [[[RestClient sharedClient]
             post:@"status" param:param]
            tryMap:^id _Nonnull(id  _Nullable value, NSError * _Nullable __autoreleasing * _Nullable errorPtr) {
        return [MTLJSONAdapter modelOfClass:[Status class] fromJSONDictionary:[value objectForKey:@"status"] error:errorPtr];
    }];
}
    
- (RACSignal *)likeStatus:(NSNumber *)statusId like:(BOOL)like {
    User *user = [[Store sharedStore].userSignal first];
    NSString *likeStr = like ? @"like" : @"cancel_like";
    return [[[RestClient sharedClient] patch:[NSString stringWithFormat:@"status/%@/%@", statusId, likeStr] param:@{@"userId" : user.Id }] map:^id(id value) {
        return [value objectForKey:@"like_count"];
    }];
}

@end
