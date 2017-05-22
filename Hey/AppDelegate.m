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

#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "Store.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //监听网络状况
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSString *token = [[Store sharedStore].tokenSignal first];
//    if () {
//        self.window = [self windowWithRootViewController:[[TabBarViewController alloc] init]];
//    }
//    else {
//        self.window = [self windowWithRootViewController:[[LoginViewController alloc] init]];
//    }
    
    //设置rootView
//    UIWindow *window;
    if (token != nil && ![token isEqualToString:@""]) {
//        self.window = [self windowWithRootViewController:[[TabBarViewController alloc] init]];
        self.window = [self windowWithRootViewController:[[TabBarViewController alloc] init]];
        
    } else {
//        self.window = [self windowWithRootViewController:[ [LoginViewController alloc] init]];
        self.window = [self windowWithRootViewController:[[UIStoryboard storyboardWithName:@"LoginViewController" bundle:nil] instantiateInitialViewController]];
    }
////    [window makeKeyAndVisible];
////    self.window = window;
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
