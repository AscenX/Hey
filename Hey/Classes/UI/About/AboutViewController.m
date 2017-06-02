//
//  AboutViewController.m
//  Hey
//
//  Created by Ascen on 2017/5/28.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "AboutViewController.h"
#import <WebKit/WebKit.h>

@interface AboutViewController ()
    
@property (nonatomic, strong) WKWebView *webView;
    

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSURL *urlPath = [NSURL fileURLWithPath:path];
    BOOL aboveIOS9 = [UIDevice currentDevice].systemVersion.doubleValue >= 9.0;
    if (aboveIOS9) {
        [self.webView loadFileURL:urlPath allowingReadAccessToURL:urlPath];
    } else {
        NSURL *fileURL = [self fileURLForBuggyWKWebView8:urlPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        [self.webView loadRequest:request];
    }
}
    
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}
    
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}
@end
