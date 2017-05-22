//
//  ChatSession.h
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface ChatSession : MTLModel <MTLFMDBSerializing>

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, copy) NSArray *userIds;
@property (nonatomic, strong) NSData *userIdsData;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *sessionName;
@property (nonatomic, copy) NSString *lastSentence;
@property (nonatomic, strong) NSDate *time;

@end
