//
//  ChatRecord.h
//  TestProtobuf
//
//  Created by Ascen on 2017/3/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface ChatRecord : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *imageURL;
@end
