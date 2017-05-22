//
//  LoginViewModel.h
//  Hey
//
//  Created by Ascen on 2017/4/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;

@interface LoginViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *password;

@property (nonatomic, strong) RACCommand *loginCommand;

@end
