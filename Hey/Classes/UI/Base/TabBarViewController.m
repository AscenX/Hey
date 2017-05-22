//
//  TabBarViewController.m
//  Hey
//
//  Created by Ascen on 2017/1/12.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "TabBarViewController.h"
#import "ProfileNavViewController.h"
#import "StatusNavViewController.h"
#import "AFNetworking.h"
#import "AppConfig.h"



@interface TabBarViewController ()

@end

@implementation TabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];

//    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"hey_db.db"];
//    NSLog(@"dbPath --- %@", dbPath);
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    
//    if ([db open]) {
//        BOOL succeed = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS appvcConfig (id integer PRIMARY KEY AUTOINCREMENT, app_vc_config blob NOT NULL)"];
//        
//        NSLog(@"%d", succeed);
//        [db close];
//    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer.acceptableContentTypes = nil;
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServerIp,AppvcConfig];
//    
//    
//    NSDictionary *para = @{@"token" : @"123123" };
    
    
//    [manager GET:urlString parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *data = (NSData*)responseObject;
//        [db open];
//        bool res = [db executeUpdate:@"insert into appvcConfig (id, app_vc_config) values (?, ?)", @125, data];
//        
//        NSLog(@"res --- %d", res);
//        
//        [db close];
//        
////        [db close];
//        //        NSLog(@"responseObject--------------%@",responseObject);
//        //        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppConfig1.json"];
//        //        NSArray* libraryArr =NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
//        //
//        //        NSString* libraryPath = [libraryArr objectAtIndex:0];
//        //        NSString *filePath = [libraryPath stringByAppendingPathComponent:@"AppConfig1.json"];
//        //
//        //        NSLog(@"%@",filePath);
//        //        //        NSFileManager* fm=[NSFileManager defaultManager];
//        //        //        bool wf = [responseObject writeToFile:filePath options:NSDataWritingAtomic error:nil];
//        //
//        //        NSDictionary* dictArr = (NSDictionary*)responseObject;
//        //        //        NSLog(@"dict --- %@", dict);
//        //
//        //        bool wf = [dictArr writeToFile:filePath atomically:YES];
//        //        if (wf) {
//        //            NSLog(@"wf successed");
//        //        } else {
//        //            NSLog(@"failed");
//        //        }
//        
//        //        NSLog(@"test");
//        
//        //        dispatch_async(dispatch_get_main_queue(), ^{
//        //            for (NSDictionary* dict in dictArr) {
//        //                NSLog(@"dict---%@", dict);
//        //                NSLog(@"dict---%@", dict[@"VcName"]);
//        //                UINavigationController* navVC = [NSClassFromString(dict[@"VcName"]) new];
//        //                navVC.title = dict[@"VcTitle"];
//        //                navVC.tabBarItem.image = [UIImage imageNamed:dict[@"VcImageName"]];
//        //                [self addChildViewController:navVC];
//        //            }
//        //        });
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: -------------%@", error);
//    }];
    
    
    
    
    
    
    
    
    
//    NSData *data = nil;
//    
//    [db open];
//    // 1.执行查询语句
//    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM appvcConfig"];
//    
////    [db close];
//    // 2.遍历结果
//    while ([resultSet next]) {
//        data = [resultSet dataForColumn:@"app_vc_config"];
//        NSLog(@"%@", data);
//    }
//    
//    [db close];
//    
//    if (data != nil) {
//        NSDictionary *appconfDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        for (NSDictionary* dict in appconfDict) {
//            NSLog(@"dict---%@", dict);
//            UINavigationController* navVC = [NSClassFromString(dict[@"VcName"]) new];
//            navVC.title = dict[@"VcTitle"];
//            navVC.tabBarItem.image = [UIImage imageNamed:dict[@"VcImageName"]];
//            [self addChildViewController:navVC];
//        }
//    } else {
//
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"json"];
////    NSArray* libraryArr =NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
////    
////    NSString* libraryPath = [libraryArr objectAtIndex:0];
////    NSString *filePath = [libraryPath stringByAppendingPathComponent:@"AppConfig1.json"];
//    
////    NSLog(@"%@",filePath);
////    NSMutableDictionary *appconfDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//
//        data = [NSData dataWithContentsOfFile:filePath];
//        NSDictionary *appconfDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    //    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
//    //    NSDictionary *appconfDict = parser
//    
//    for (NSDictionary* dict in appconfDict) {
//        NSLog(@"dict---%@", dict);
//        UINavigationController* navVC = [NSClassFromString(dict[@"VcName"]) new];
//        navVC.title = dict[@"VcTitle"];
//        navVC.tabBarItem.image = [UIImage imageNamed:dict[@"VcImageName"]];
//        [self addChildViewController:navVC];
//    }
//    
//    }
    
    

    
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
//    manager.responseSerializer.acceptableContentTypes = nil;
////    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServerIp,AppvcConfig];
//
//    
//    NSDictionary *para = @{@"token" : @"123123" };
//    
//    
//    [manager GET:urlString parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
////        NSLog(@"responseObject--------------%@",responseObject);
//        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppConfig.json"];
////        NSFileManager* fm=[NSFileManager defaultManager];
////        bool wf = [responseObject writeToFile:filePath options:NSDataWritingAtomic error:nil];
//        
//        NSDictionary* dictArr = (NSDictionary*)responseObject;
////        NSLog(@"dict --- %@", dict);
//        
//        bool wf = [dictArr writeToFile:filePath atomically:YES];
//        if (wf) {
//            NSLog(@"wf successed");
//        } else {
//            NSLog(@"failed");
//        }
//        
//        
////        dispatch_async(dispatch_get_main_queue(), ^{
////            for (NSDictionary* dict in dictArr) {
////                NSLog(@"dict---%@", dict);
////                NSLog(@"dict---%@", dict[@"VcName"]);
////                UINavigationController* navVC = [NSClassFromString(dict[@"VcName"]) new];
////                navVC.title = dict[@"VcTitle"];
////                navVC.tabBarItem.image = [UIImage imageNamed:dict[@"VcImageName"]];
////                [self addChildViewController:navVC];
////            }
////        });
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: -------------%@", error);
//    }];
    
    
    
//    [task resume];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fuck" ofType:@"json"];
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"fuck" ofType:@"json"];
//    NSMutableDictionary *appconfDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
////    data = [NSData dataWithContentsOfFile:filePath];
////    NSDictionary *appconfDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
////    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
////    NSDictionary *appconfDict = parser
//    
//    for (NSDictionary* dict in appconfDict) {
//        NSLog(@"dict---%@", dict);
//        UINavigationController* navVC = [NSClassFromString(dict[@"VcName"]) new];
//        navVC.title = dict[@"VcTitle"];
//        navVC.tabBarItem.image = [UIImage imageNamed:dict[@"VcImageName"]];
//        [self addChildViewController:navVC];
//    }
    
//    UINavigationController* heyNavVC = [HomeNavViewController new];
//    [heyNavVC setTitle:@"主页"];
//    [self addChildViewController: heyNavVC];
//    
//    UINavigationController* contactsNavVC = [ContactsNavViewController new];
//    [contactsNavVC setTitle:@"通讯录"];
//    [self addChildViewController:contactsNavVC];
//    
//    
//    UINavigationController* statusNavVC = [StatusNavViewController new];
//    [statusNavVC setTitle:@"动态"];
//    [self addChildViewController:statusNavVC];
//    
//    UINavigationController* profileNavVC = [ProfileNavViewController new];
//    [profileNavVC setTitle:@"我"];
//    [self addChildViewController:profileNavVC];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
