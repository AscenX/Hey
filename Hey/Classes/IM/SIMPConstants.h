//
//  SIMPConstants.h
//  Hey
//
//  Created by Ascen on 2017/3/24.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CheckError(what, error) do {\
if (*error) {\
NSLog(@"%@ error----%@",what, *error);\
}\
} while(0)\

extern int32_t const SIMPVersion;
