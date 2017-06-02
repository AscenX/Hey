//
//  TabBarViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/12.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "TabBarViewController.h"

#import "SessionViewController.h"
#import "ContactsViewController.h"
#import "StatusViewController.h"
#import "ProfileViewController.h"

#import "UIColor+Help.h"



@interface TabBarViewController ()

@end

@implementation TabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController* sessionVC = [[SessionViewController alloc] init];
    [sessionVC setTitle:@"Hey"];
    UINavigationController *sessionNav = [[UINavigationController alloc] initWithRootViewController:sessionVC];
    sessionNav.tabBarItem.image = [UIImage imageNamed:@"icon_chat"];
    [self addChildViewController:sessionNav];
    
    UIViewController* contactsVC = [[ContactsViewController alloc] init];
    [contactsVC setTitle:@"通讯录"];
    UINavigationController *contactsNav = [[UINavigationController alloc] initWithRootViewController:contactsVC];
    contactsNav.tabBarItem.image = [UIImage imageNamed:@"icon_contact"];
    [self addChildViewController:contactsNav];
    
    UIViewController *statusVC = [[StatusViewController alloc] initWithFromMyStatus:NO];
    [statusVC setTitle:@"动态"];
    UINavigationController *statusNav = [[UINavigationController alloc] initWithRootViewController:statusVC];
    statusNav.tabBarItem.image = [UIImage imageNamed:@"icon_status"];
    [self addChildViewController:statusNav];
    
    UIViewController* profileVC = [[ProfileViewController alloc] init];
    [profileVC setTitle:@"我"];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNav.tabBarItem.image = [UIImage imageNamed:@"icon_me"];
    [self addChildViewController:profileNav];
    
    [self.tabBar setTintColor:[UIColor colorWithHex:0x4990E2]];
    [self.tabBar setUnselectedItemTintColor:[UIColor colorWithHex:0xCCC9CD]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
