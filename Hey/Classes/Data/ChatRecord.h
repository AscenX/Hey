//
//  ChatRecord.h
//  TestProtobuf
//
//  Created by Ascen on 2017/3/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRecord : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *imageURL;
@end
