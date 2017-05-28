//
//  UserManager.h
//  Hey
//
//  Created by Ascen on 2017/4/21.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@class User;

@interface UserManager : NSObject

+ (instancetype)sharedManager;

- (RACSignal *)loginWithUserId:(NSString *)userId password:(NSString *)password;

- (RACSignal *)fetchContactsWithUserId:(NSString *)userId;

- (User *)getUserById:(NSNumber *)userId;

@end
