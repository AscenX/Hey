//
//  ChatSession.h
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatSession : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *sessionName;
@property (nonatomic, strong) NSString *lastSentence;
@property (nonatomic, strong) NSDate *time;


@end
