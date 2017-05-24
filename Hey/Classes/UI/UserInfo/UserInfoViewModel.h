//
//  UserInfoViewModel.h
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@class User;

@interface UserInfoViewModel : NSObject

@property (nonatomic, strong, readonly) User *user;

- (instancetype)initWithUser:(User *)user;

@property (nonatomic, strong, readonly) NSArray *userInfo;

@property (nonatomic, strong, readonly) NSArray *statusImages;

@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *userId;

@end
