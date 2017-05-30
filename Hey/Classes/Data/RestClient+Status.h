//
//  RestClient+Status.h
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "RestClient.h"
#import "Status.h"

@interface RestClient (Status)

- (RACSignal *)statusByUserId:(NSNumber *)userId;

- (RACSignal *)sendStatus:(Status *)status withUserId:(NSNumber *)userId;


@end
