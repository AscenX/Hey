//
//  Status.h
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface Status : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, strong) NSNumber *likeNum;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSNumber *imageScale;
@property (nonatomic, assign) BOOL youLike;

@end
