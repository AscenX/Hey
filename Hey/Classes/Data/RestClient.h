//
//  RestClient.h
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "Store.h"

extern NSString * const RestClientErrorDomain;

@interface RestClient : NSObject

+ (instancetype)sharedClient;

- (RACSignal *)get:(NSString *)path param:(NSDictionary *)param;
- (RACSignal *)post:(NSString *)path param:(NSDictionary *)param;
- (RACSignal *)patch:(NSString *)path param:(NSDictionary *)param;


@end
