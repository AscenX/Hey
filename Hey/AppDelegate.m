//
//  AppDelegate.m
//  Hey
//
//  Created by Ascen on 2017/1/12.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "DBMigrationHelper.h"

#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "Store.h"
#import "SIMPConnection.h"
#import "Constants.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //database
    DBMigrationHelper *dbMigrationHelper = [DBMigrationHelper sharedInstance];
    [dbMigrationHelper setup];
    
    //监听网络状况
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //设置rootView，如果已经登录则直接跳转到主界面
    NSString *token = [[Store sharedStore].tokenSignal first];
    User *user = [[Store sharedStore].userSignal first];
    if (token != nil && user != nil) {
//        BOOL success = [[SIMPConnection sharedConnection] connectToRemoteHost:serverAddress port:socketPort forUser:user.Id.stringValue];
        BOOL success = [[SIMPConnection sharedConnection] connectionToRemoteHost:serverHost port:socketPort forUser:user.Id.stringValue];
        NSLog(@"connect to socket server %@", success ? @"YES" : @"NO");
        self.window = [self windowWithRootViewController:[[TabBarViewController alloc] init]];
    } else {
        self.window = [self windowWithRootViewController:[[UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil] instantiateInitialViewController]];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIWindow *)windowWithRootViewController:(UIViewController *)root {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = root;
    return window;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
