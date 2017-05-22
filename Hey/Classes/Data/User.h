//
//  User.h
//  Hey
//
//  Created by Ascen on 2017/5/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface User : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

@property (nonatomic, copy) NSNumber *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;

@end
