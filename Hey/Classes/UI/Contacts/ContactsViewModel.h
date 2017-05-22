//
//  ContactsViewModel.h
//  Hey
//
//  Created by Ascen on 2017/5/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ContactsViewModel : NSObject

@property (nonatomic, strong) NSArray *contacts;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, strong) RACCommand *fetchContactsCommand;


@end
