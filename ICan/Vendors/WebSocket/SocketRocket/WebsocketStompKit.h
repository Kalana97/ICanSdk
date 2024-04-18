//
//  WebsocketStompKit.h
//  WebsocketStompKit
//
//  Created by Jeff Mesnil on 09/10/2013.
//  Modified by Robin Guldener on 17/03/2015
//  Copyright (c) 2013 Jeff Mesnil & Robin Guldener. All rights reserved.
//
/**
 pingdata 发送 send 方法
 */
#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#pragma mark Frame headers

#define kHeaderAcceptVersion @"accept-version"
#define kHeaderAck           @"ack"
#define kHeaderContentLength @"content-length"
#define kHeaderDestination   @"destination"
#define kHeaderHeartBeat     @"heart-beat"
#define kHeaderHost          @"host"
#define kHeaderID            @"id"
#define kHeaderLogin         @"login"
#define kHeaderMessage       @"message"
#define kHeaderPasscode      @"passcode"
#define kHeaderReceipt       @"receipt"
#define kHeaderReceiptID     @"receipt-id"
#define kHeaderSession       @"session"
#define kHeaderSubscription  @"subscription"
#define kHeaderTransaction   @"transaction"

#pragma mark Ack Header Values

#define kAckAuto             @"auto"
#define kAckClient           @"client"
#define kAckClientIndividual @"client-individual"

@class STOMPFrame;
@class STOMPMessage;

typedef void (^STOMPFrameHandler)(STOMPFrame *frame);
typedef void (^STOMPMessageHandler)(STOMPMessage *message);

#pragma mark STOMP Frame

@interface STOMPFrame : NSObject

@property (nonatomic, copy, readonly) NSString *command;
@property (nonatomic, copy, readonly) NSDictionary *headers;
@property (nonatomic, copy, readonly) NSString *body;

@end

#pragma mark STOMP Message

@interface STOMPMessage : STOMPFrame

- (void)ack;
- (void)ack:(NSDictionary *)theHeaders;
- (void)nack;
- (void)nack:(NSDictionary *)theHeaders;

@end

#pragma mark STOMP Subscription

@interface STOMPSubscription : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
/** 订阅地址 */
@property (nonatomic,copy ,readonly)  NSString *subscriptionAddress;

- (void)unsubscribe;

@end

#pragma mark STOMP Transaction

@interface STOMPTransaction : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;

- (void)commit;
- (void)abort;

@end

@protocol STOMPClientDelegate

@optional


/**
 socket连接失败

 @param webSocket webSocket description
 @param error error description
 */
- (void) websocketDidDisconnectJFRWebSocket:(SRWebSocket*)webSocket error:(NSError *)error;

/**
 websocket成功连接

 @param stompFrame stompFrame description
 */
- (void) webSocketDidConnect:(STOMPFrame*)stompFrame;


/**
 socket连接成功但是服务器返回了失败

 @param stompFrame stompFrame description
 @param error error description
 */
- (void) webSocketConnectWithStompFrame:(STOMPFrame*)stompFrame Error:(NSError*)error;
@end

#pragma mark STOMP Client

@interface STOMPClient : NSObject

@property (nonatomic, copy) STOMPFrameHandler receiptHandler;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, readonly) BOOL heartbeatActivated;
@property (nonatomic, weak) id <STOMPClientDelegate> delegate;


/**
 初始化客户端连接

 @param theUrl 连接webSocket的地址
 @param headers 头部信息
 @param heartbeat 是否需要心跳
 @return return value description
 */
- (id)initWithURL:(NSURL *)theUrl webSocketHeaders:(NSDictionary *)headers useHeartbeat:(BOOL)heartbeat;


- (void)connectWithLogin:(NSString *)login
                passcode:(NSString *)passcode
       completionHandler:(void (^)(STOMPFrame *connectedFrame, NSError *error))completionHandler;

/**
 连接webSocket

 @param headers 头部信息
 @param completionHandler 状态回调
 */
- (void)connectWithHeaders:(NSDictionary *)headers
         completionHandler:(void (^)(STOMPFrame *connectedFrame, NSError *error))completionHandler;

/**
 连接webSocket

 @param headers headers description
 */
-(void)connectWithHeaders:(NSDictionary *)headers;


/**
 发送消息
 @param destination 消息地址
 @param body 内容
 */
- (void)sendTo:(NSString *)destination
          body:(NSString *)body;

- (void)sendTo:(NSString *)destination
       headers:(NSDictionary *)headers
          body:(NSString *)body;

/**
 订阅某个地址

 @param destination 订阅地址
 @param handler 回调
 @return STOMPSubscription
 */
- (STOMPSubscription *)subscribeTo:(NSString *)destination
                    messageHandler:(STOMPMessageHandler)handler;
- (STOMPSubscription *)subscribeTo:(NSString *)destination
                           headers:(NSDictionary *)headers
                    messageHandler:(STOMPMessageHandler)handler;

- (STOMPTransaction *)begin;
- (STOMPTransaction *)begin:(NSString *)identifier;

- (void)disconnect;

@end
