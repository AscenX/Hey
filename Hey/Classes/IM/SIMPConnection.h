//
//  SIMPConnection.h
//  Hey
//
//  Created by Ascen on 2017/3/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/CocoaAsyncSocket-umbrella.h>

@class SIMPConnection;
@class SIMPMessage;

@protocol SIMPConnectionDelegate <NSObject>

@optional
- (void)connection:(SIMPConnection *)connection didConnectToAddress:(NSData *)adress bySocket:(id)sock;
- (void)connection:(SIMPConnection *)connection didClosedWithError:(NSError *)error bySocket:(id)sock;
- (void)connection:(SIMPConnection *)connection didSendMessageBySocket:(id)sock;
- (void)connection:(SIMPConnection *)connection didReceiveMessage:(SIMPMessage *)msg bySocket:(id)sock;
- (void)connection:(SIMPConnection *)connection didSendMessageFailedDueToError:(NSError *)err bySocket:(id)sock;
@end

@interface SIMPConnection : NSObject

@property (nonatomic, strong) GCDAsyncSocket *tcpSocket;
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, assign, getter=isConnected) BOOL connected;
@property (nonatomic, weak) id<SIMPConnectionDelegate> delegate;
@property (nonatomic, assign) uint16_t port;
@property (nonatomic, copy) NSString *host;

+ (instancetype)sharedConnection;
- (BOOL)connectionToRemoteHost:(NSString *)host port:(NSInteger)port forUser:(NSString *)userID;
- (void)sendMessage:(SIMPMessage *)message;
- (NSData *)getCurrentAddress;

@end




