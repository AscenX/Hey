//
//  RestClient.m
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "RestClient.h"
#import "Constants.h"
#import "Store.h"
#import "AccessTokenStore.h"

#import <AFNetworking/AFNetworking.h>

@interface RestClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end


NSString * const RestClientErrorDomain = @"RestClientErrorDomain";

@implementation RestClient

+ (instancetype)sharedClient
{
    static RestClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

- (instancetype)init {
    if (self = [super init]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@:%ld/%@", httpPrefix, serverHost, (long)httpPort, apiVersion]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForResource = 15;
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:config];
        dispatch_queue_t queue = dispatch_queue_create("com.ascen.hey", DISPATCH_QUEUE_SERIAL );
        _sessionManager.completionQueue = queue;
        _semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (RACSignal *)get:(NSString *)path param:(NSDictionary *)param {
    return [self performRequestWithMethod:@"GET" path:path parameters:param];
}

- (RACSignal *)post:(NSString *)path param:(NSDictionary *)param {
    return [self performRequestWithMethod:@"POST" path:path parameters:param];
}

- (RACSignal *)patch:(NSString *)path param:(NSDictionary *)param {
    return [self performRequestWithMethod:@"PATCH" path:path parameters:param];
}

- (RACSignal *)performRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *URLString = [[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString];
        NSURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:nil];
        return [[self performRequest:request] subscribe:subscriber];
    }] subscribeOn:[RACScheduler scheduler]];
    return signal;
}

- (RACSignal *)performRequest:(NSURLRequest *)request {
    NSString *requestTokenPath = [request.URL.absoluteString substringFromIndex:request.URL.absoluteString.length - 11];
    if (![requestTokenPath isEqualToString:@"accesstoken"]) {
        request = [self authorisedRequestWithReqeust:request];
    }
    return [self signalWithRequest:request];
}

- (NSURLRequest *)authorisedRequestWithReqeust:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *token = [[AccessTokenStore sharedStore] getAccessToken];
    [mutableRequest setValue:token forHTTPHeaderField:@"accesstoken"];
    return [mutableRequest copy];
}


- (RACSignal *)signalWithRequest:(NSURLRequest *)request {
    @weakify(self)
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            @strongify(self)
            if (error) {
                error = [self errorWithError:error responseObject:responseObject];
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
#if DEBUG
    NSString *contentType = [request.allHTTPHeaderFields objectForKey:@"Content-Type"];
    if ([contentType isEqualToString:@"application/x-www-form-urlencoded"] && request.HTTPBody) {
        NSString *urlencoded = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        urlencoded = [urlencoded stringByRemovingPercentEncoding];
        signal = [[[signal setNameWithFormat:@"%@ %@ %@ %@", request.HTTPMethod, request.URL, urlencoded, request.allHTTPHeaderFields] logNext] logError];
    } else if ([contentType isEqualToString:@"application/json"]){
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:kNilOptions error:NULL];
        signal = [[[signal setNameWithFormat:@"%@ %@ %@ %@", request.HTTPMethod, request.URL, json, request.allHTTPHeaderFields] logNext] logError];
        
    } else {
        NSString *url = [request.URL absoluteString];
        url = [url stringByRemovingPercentEncoding];
        signal = [[[signal setNameWithFormat:@"%@ %@ %@", request.HTTPMethod, url, request.allHTTPHeaderFields] logNext] logError];
    }
#endif
    return signal;
}

- (NSError *)errorWithError:(NSError *)error responseObject:(NSDictionary *)responseObject {
    NSInteger code = error.code;
    NSString *localizedDescription;
    NSDictionary *userInfo = error.userInfo;
    
    NSHTTPURLResponse *response =[userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
    if (response) {
        code = response.statusCode;
    }
    if (code == 1002) {
        localizedDescription = @"登录失效，请重新登录";
    }
    else if (code == 1001) {
        localizedDescription = @"用户名或密码错误";
    }
    else if (code == 404) {
        localizedDescription = @"无效请求";
    }
    else if (code == 422) {
        NSArray *reasons = [responseObject valueForKey:@"errors"];
        if (reasons && reasons.count > 0) {
            localizedDescription = [reasons firstObject];
        }
    }
    else if (code >= 500) {
        localizedDescription = @"服务暂不可用，请稍后重试";
    } else {
        localizedDescription = [userInfo objectForKey:@"NSLocalizedDescription"];
    }
    
    if (localizedDescription) {
        NSMutableDictionary *mutable = [userInfo mutableCopy];
        [mutable setObject:localizedDescription forKey:NSLocalizedDescriptionKey];
        NSData *data = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        if (data) {
            NSString *reason = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [mutable setObject:reason forKey:@"com.alamofire.serialization.response.error.data"];
            [mutable removeObjectForKey:NSUnderlyingErrorKey];
            [mutable removeObjectForKey:NSURLErrorFailingURLStringErrorKey];
        }
        userInfo = [mutable copy];
        return [NSError errorWithDomain:RestClientErrorDomain code:code userInfo:userInfo];
    }
    return error;
}

@end
