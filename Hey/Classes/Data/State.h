//
//  State.h
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Viewer.h"
#import <Mantle/Mantle.h>


@interface State : MTLModel <MTLJSONSerializing>

+ (instancetype)createWithState:(State *)old key:(NSString *)key value:(id)value;

@property (nonatomic, strong, readonly) Viewer *viewer;

@end
