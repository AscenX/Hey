//
//  ProfileViewModel.h
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ProfileViewModel : NSObject

@property (nonatomic, copy) NSArray *infos;

@property (nonatomic, strong) RACCommand *logoutCommand;

@end
