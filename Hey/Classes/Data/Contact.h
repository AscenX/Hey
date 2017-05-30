//
//  Contact.h
//  Hey
//
//  Created by Ascen on 2017/5/21.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface Contact : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

@property (nonatomic, copy) NSNumber *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;

@end
