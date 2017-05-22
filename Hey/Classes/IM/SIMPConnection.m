//
//  SIMPConnection.m
//  Hey
//
//  Created by Ascen on 2017/3/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SIMPConnection.h"
#import "SIMPConstants.h"
#import <sys/socket.h>
#import "Message.pbobjc.h"
#import "SIMPMessage.h"



@interface SIMPConnection () <GCDAsyncSocketDelegate, GCDAsyncUdpSocketDelegate>

@property (nonatomic, assign) NSString *userID;
@end

@implementation SIMPConnection

//singleton
+ (instancetype)sharedConnection
{
    static SIMPConnection *sharedConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnection = [[self alloc] init];
    });
    return sharedConnection;
}

+ (void)connectToHost:(NSString *)host port:(NSInteger)port forUser:(NSString *)userID {
    SIMPConnection *connection = [[SIMPConnection sharedConnection] initWithRemoteHost:host port:port forUser:userID];
    if (!connection) {
        NSLog(@"connection init error");
    }
}

- (instancetype)initWithRemoteHost:(NSString *)host port:(NSInteger)port forUser:(NSString *)userID {
    
    if (self = [super init]) {
        _host = host;
        _port = port;
        _userID = userID;
        _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self connect];
    }
    return self;
}

- (void)connect {
    if (![self.tcpSocket isConnected] && ![self.udpSocket isConnected]) {
        NSError *error;
        BOOL success = [self.tcpSocket connectToHost:self.host onPort:self.port error:&error];
        NSLog(@"tcp conntect --%@", @(success));
        CheckError(@"TCPSocketConnectToHost", &error);
        
        
        [self.udpSocket connectToHost:self.host onPort:self.port + 1 error:&error];
        CheckError(@"UDPSocketConnectToHost", &error);
        [self.udpSocket beginReceiving:&error];
        CheckError(@"beginReceiving", &error);
        
        NSLog(@"----%@---%hu",self.tcpSocket.localHost, self.tcpSocket.localPort);
        NSLog(@"----%@---%hu",self.udpSocket.localHost, self.udpSocket.localPort);
        
        [self sendConnectData];
    }
}

- (BOOL)isConnected {
    return self.udpSocket.isConnected && self.tcpSocket.isConnected;
}

- (void)sendConnectData {
    Message *connectData = [[Message alloc] init];
    connectData.fromUser = self.userID;
    connectData.version = SIMPVersion;
    connectData.type = Message_MessageType_Connect;
    NSLog(@"UDP地址是: %@:%hu", self.udpSocket.localHost, self.udpSocket.localPort);
    connectData.content = [NSString stringWithFormat:@"%@:%hu", self.udpSocket.localHost, self.udpSocket.localPort];
    [self.tcpSocket writeData:connectData.data withTimeout:15 tag:0];
}

- (void)sendData:(NSData *)data tag:(long)tag {
    if (tag == 2) {
        [self.udpSocket sendData:data withTimeout:15 tag:tag];
    } else {
        [self.tcpSocket writeData:data withTimeout:15 tag:tag];
    }
}

- (void)dealloc {
}

- (NSData *)getCurrentAddress {
    if ([self.tcpSocket isConnected]) {
        return self.tcpSocket.localAddress;
    } else {
        return nil;
    }
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSLog(@"socket--%@---didConnectToAddress----adress---%@",sock, address);
    [self.delegate connection:self didConnectToAdress:address bySocket:sock];
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    NSLog(@"socket--%@--didNotConnect----adress---%@",sock, error);
    [self.delegate connection:self didClosedWithError:error bySocket:sock];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"socket--%@---didSendDataWithTag---%ld",sock, tag);
    [self.delegate connection:self didSendData:nil bySocket:sock];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {

    NSLog(@"socket---%@---didNotSendDataWithTag---tag--%ld",sock, tag);
    [self.delegate connection:self didSendDataFailedDueToError:error bySocket:sock];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext {
    NSLog(@"didReceiveData----data--%@---adress---%@",data, address);
    NSError *error;
    Message *message = [Message parseFromData:data error:&error];
    SIMPMessage *simpMessage = [[SIMPMessage alloc] initWithMessage:message];
    [self.delegate connection:self didReceiveMessage:simpMessage bySocket:sock];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
    NSLog(@"udpSocketDidClose----socket--%@---adress---%@",sock, error);
    [self.delegate connection:self didClosedWithError:error bySocket:sock];
}

#pragma mark - GCDAsyncSocketDelegate

- (nullable dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock {
    NSLog(@"%s",__func__);
    return nil;
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"%s",__func__);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"socket--%@---didConnectToHost---%@---port--%hu",sock, host, port);
    NSString *adress =  [host stringByAppendingString:[NSString stringWithFormat:@":%hu", port]];
    [self.delegate connection:self didConnectToAdress:[adress dataUsingEncoding:NSUTF8StringEncoding] bySocket:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToUrl:(NSURL *)url {
    NSLog(@"socket--%@---didConnectToUrl----url---%@",sock, url);
    [self.delegate connection:self didConnectToAdress:[[url absoluteString] dataUsingEncoding:NSUTF8StringEncoding] bySocket:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"socket--%@---didReadData----data---%@---tag---%ld",sock, data, tag);
    NSError *error;
    Message *message = [Message parseFromData:data error:&error];
    SIMPMessage *simpMessage = [[SIMPMessage alloc] initWithMessage:message];
    [self.delegate connection:self didReceiveMessage:simpMessage bySocket:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"%s",__func__);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"socket--%@---didWriteDataWithTag----tag---%ld",sock, tag);
    [self.delegate connection:self didSendData:nil bySocket:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
    NSLog(@"%s",__func__);
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length {
    NSLog(@"%s",__func__);
    return 0;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length {
    NSLog(@"%s",__func__);
    return 0;
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock {
    NSLog(@"socket--%@---socketDidCloseReadStream", sock);
    [self.delegate connection:self didClosedWithError:nil bySocket:sock];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"socket--%@---socketDidDisconnectWithError----%@", sock, err);
    [self.delegate connection:self didClosedWithError:err bySocket:sock];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock {
    NSLog(@"%s",__func__);
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler {
    NSLog(@"%s",__func__);
}

@end
