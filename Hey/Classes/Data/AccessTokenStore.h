//
//  AccessTokenStore.h
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessTokenStore : NSObject

+ (instancetype)sharedStore;

- (NSString *)getToken;

- (void)updateToken:(NSString *)token;

- (void)clearToken;

@end
