//
//  HomeViewModel.h
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatSession;

@interface SessionViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray *sessions;

- (void)updateSessions;

@end
