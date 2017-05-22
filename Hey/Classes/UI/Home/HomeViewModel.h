//
//  HomeViewModel.h
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatSession;

@interface HomeViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<ChatSession *> *sessions;

- (void)updateSessions;

@end
