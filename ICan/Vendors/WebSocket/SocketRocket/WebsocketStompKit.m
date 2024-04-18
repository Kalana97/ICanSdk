//
//  WebsocketStompKit.m
//  WebsocketStompKit
//
//  Created by Jeff Mesnil on 09/10/2013.
//  Modified by Robin Guldener on 17/03/2015
//  Copyright (c) 2013 Jeff Mesnil & Robin Guldener. All rights reserved.
//

#import "WebsocketStompKit.h"

#define kDefaultTimeout 5
#define kVersion1_2 @"1.2"

#define WSProtocols @[]//@[@"v10.stomp", @"v11.stomp"]

#pragma mark Logging macros

#ifdef DEBUG // set to 1 to enable logs

#define LogDebug(frmt, ...) NSLog(frmt, ##__VA_ARGS__);

#else

#define LogDebug(frmt, ...) {}

#endif

#pragma mark Frame commands

#define kCommandAbort       @"ABORT"
#define kCommandAck         @"ACK"
#define kCommandBegin       @"BEGIN"
#define kCommandCommit      @"COMMIT"
#define kCommandConnect     @"CONNECT"
#define kCommandConnected   @"CONNECTED"
#define kCommandDisconnect  @"DISCONNECT"
#define kCommandError       @"ERROR"
#define kCommandMessage     @"MESSAGE"
#define kCommandNack        @"NACK"
#define kCommandReceipt     @"RECEIPT"
#define kCommandSend        @"SEND"
#define kCommandSubscribe   @"SUBSCRIBE"
#define kCommandUnsubscribe @"UNSUBSCRIBE"

#pragma mark Control characters

#define    kLineFeed @"\x0A"
#define    kNullChar @"\x00"
#define kHeaderSeparator @":"

#pragma mark -
#pragma mark STOMP Client private interface

@interface STOMPClient()<SRWebSocketDelegate>

@property (nonatomic, retain) SRWebSocket *socket;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *host;
@property (nonatomic) NSString *clientHeartBeat;
@property (nonatomic, weak) NSTimer *pinger;
@property (nonatomic, weak) NSTimer *ponger;
@property (nonatomic, assign) BOOL heartbeat;
@property (nonatomic, copy) NSDictionary *connectFrameHeaders;
@property (nonatomic, retain) NSMutableDictionary *subscriptions;

- (void) sendFrameWithCommand:(NSString *)command
                      headers:(NSDictionary *)headers
                         body:(NSString *)body;

@end

#pragma mark STOMP Frame

@interface STOMPFrame()

- (id)initWithCommand:(NSString *)theCommand
              headers:(NSDictionary *)theHeaders
                 body:(NSString *)theBody;

- (NSData *)toData;

@end

@implementation STOMPFrame

@synthesize command, headers, body;

- (id)initWithCommand:(NSString *)theCommand
              headers:(NSDictionary *)theHeaders
                 body:(NSString *)theBody {
    if(self = [super init]) {
        command = theCommand;
        headers = theHeaders;
        body = theBody;
    }
    return self;
}

- (NSString *)toString {
    NSMutableString *frame = [NSMutableString stringWithString: [self.command stringByAppendingString:kLineFeed]];
    for (id key in self.headers) {
        [frame appendString:[NSString stringWithFormat:@"%@%@%@%@", key, kHeaderSeparator, self.headers[key], kLineFeed]];
    }
    [frame appendString:kLineFeed];
    if (self.body) {
        [frame appendString:self.body];
    }
    [frame appendString:kNullChar];
    return frame;
}

- (NSData *)toData {
    return [[self toString] dataUsingEncoding:NSUTF8StringEncoding];
}

+ (STOMPFrame *) STOMPFrameFromData:(NSData *)data {
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length])];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    NSMutableArray *contents = (NSMutableArray *)[[msg componentsSeparatedByString:kLineFeed] mutableCopy];
    while ([contents count] > 0 && [contents[0] isEqual:@""]) {
        [contents removeObjectAtIndex:0];
    }
    if (!contents.count) {
        return nil;
    }
    NSString *command = [[contents objectAtIndex:0] copy];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    NSMutableString *body = [[NSMutableString alloc] init];
    BOOL hasHeaders = NO;
    [contents removeObjectAtIndex:0];
    for(NSString *line in contents) {
        if(hasHeaders) {
            for (int i=0; i < [line length]; i++) {
                unichar c = [line characterAtIndex:i];
                if (c != '\x00') {
                    [body appendString:[NSString stringWithFormat:@"%c", c]];
                }
            }
        } else {
            if ([line isEqual:@""]) {
                hasHeaders = YES;
            } else {
                NSMutableArray *parts = [NSMutableArray arrayWithArray:[line componentsSeparatedByString:kHeaderSeparator]];
                // key ist the first part
                NSString *key = parts[0];
                [parts removeObjectAtIndex:0];
                headers[key] = [parts componentsJoinedByString:kHeaderSeparator];
            }
        }
    }
    return [[STOMPFrame alloc] initWithCommand:command headers:headers body:body];
}

- (NSString *)description {
    return [self toString];
}


@end

#pragma mark STOMP Message

@interface STOMPMessage()

@property (nonatomic, retain) STOMPClient *client;

+ (STOMPMessage *)STOMPMessageFromFrame:(STOMPFrame *)frame
                                 client:(STOMPClient *)client;

@end

@implementation STOMPMessage

@synthesize client;

- (id)initWithClient:(STOMPClient *)theClient
             headers:(NSDictionary *)theHeaders
                body:(NSString *)theBody {
    if (self = [super initWithCommand:kCommandMessage
                              headers:theHeaders
                                 body:theBody]) {
        self.client = theClient;
    }
    return self;
}

- (void)ack {
    [self ackWithCommand:kCommandAck headers:nil];
}

- (void)ack: (NSDictionary *)theHeaders {
    [self ackWithCommand:kCommandAck headers:theHeaders];
}

- (void)nack {
    [self ackWithCommand:kCommandNack headers:nil];
}

- (void)nack: (NSDictionary *)theHeaders {
    [self ackWithCommand:kCommandNack headers:theHeaders];
}

- (void)ackWithCommand: (NSString *)command
               headers: (NSDictionary *)theHeaders {
    NSMutableDictionary *ackHeaders = [[NSMutableDictionary alloc] initWithDictionary:theHeaders];
    ackHeaders[kHeaderID] = self.headers[kHeaderAck];
    [self.client sendFrameWithCommand:command
                              headers:ackHeaders
                                 body:nil];
}

+ (STOMPMessage *)STOMPMessageFromFrame:(STOMPFrame *)frame
                                 client:(STOMPClient *)client {
    return [[STOMPMessage alloc] initWithClient:client headers:frame.headers body:frame.body];
}

@end

#pragma mark STOMP Subscription

@interface STOMPSubscription()

@property (nonatomic, retain) STOMPClient *client;
@property (nonatomic,copy )  NSString *subscriptionAddress;

- (id)initWithClient:(STOMPClient *)theClient
          identifier:(NSString *)theIdentifier subscriptionAddress:(NSString*)subscriptionAddress;

@end

@implementation STOMPSubscription

@synthesize client;
@synthesize identifier;

- (id)initWithClient:(STOMPClient *)theClient
          identifier:(NSString *)theIdentifier subscriptionAddress:(NSString*)subscriptionAddress {
    if(self = [super init]) {
        self.client = theClient;
        self.subscriptionAddress=subscriptionAddress;
        identifier = [theIdentifier copy];
    }
    return self;
}

- (void)unsubscribe {
    [self.client sendFrameWithCommand:kCommandUnsubscribe
                              headers:@{kHeaderID: self.identifier}
                                 body:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<STOMPSubscription identifier:%@>", identifier];
}

@end

#pragma mark STOMP Transaction

@interface STOMPTransaction()

@property (nonatomic, retain) STOMPClient *client;

- (id)initWithClient:(STOMPClient *)theClient
          identifier:(NSString *)theIdentifier;

@end

@implementation STOMPTransaction

@synthesize identifier;

- (id)initWithClient:(STOMPClient *)theClient
          identifier:(NSString *)theIdentifier {
    if(self = [super init]) {
        self.client = theClient;
        identifier = [theIdentifier copy];
    }
    return self;
}

- (void)commit {
    [self.client sendFrameWithCommand:kCommandCommit
                              headers:@{kHeaderTransaction: self.identifier}
                                 body:nil];
}

- (void)abort {
    [self.client sendFrameWithCommand:kCommandAbort
                              headers:@{kHeaderTransaction: self.identifier}
                                 body:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<STOMPTransaction identifier:%@>", identifier];
}

@end

#pragma mark STOMP Client Implementation

@implementation STOMPClient

@synthesize socket, url, host, heartbeat;
@synthesize connectFrameHeaders;
@synthesize receiptHandler;
@synthesize subscriptions;
@synthesize pinger, ponger;
@synthesize delegate;

int idGenerator;
CFAbsoluteTime serverActivity;

#pragma mark -
#pragma mark Public API

- (id)initWithURL:(NSURL *)theUrl webSocketHeaders:(NSDictionary *)headers useHeartbeat:(BOOL)heart {
    if(self = [super init]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:theUrl];
        request.allHTTPHeaderFields = headers;
        self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
        self.socket.delegate = self;
        self.heartbeat = heart;
        self.url = theUrl;
        self.host = theUrl.host;
        idGenerator = 0;
        self.connected = NO;
        self.subscriptions = [[NSMutableDictionary alloc] init];
        self.clientHeartBeat = @"5000,5000";
    }
    return self;
}

- (BOOL) heartbeatActivated {
    return heartbeat;
}

- (void)connectWithLogin:(NSString *)login
                passcode:(NSString *)passcode
       completionHandler:(void (^)(STOMPFrame *connectedFrame, NSError *error))completionHandler {
    [self connectWithHeaders:@{kHeaderLogin: login, kHeaderPasscode: passcode}
           completionHandler:completionHandler];
}

- (void)connectWithHeaders:(NSDictionary *)headers
         completionHandler:(void (^)(STOMPFrame *connectedFrame, NSError *error))completionHandler {
    self.connectFrameHeaders = headers;
    [self.socket open];
}
-(void)connectWithHeaders:(NSDictionary *)headers{
     self.connectFrameHeaders = headers;
     [self.socket open];
}
- (void)sendTo:(NSString *)destination
          body:(NSString *)body {
    [self sendTo:destination
         headers:nil
            body:body];
}

- (void)sendTo:(NSString *)destination
       headers:(NSDictionary *)headers
          body:(NSString *)body {
    NSMutableDictionary *msgHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
    msgHeaders[kHeaderDestination] = destination;
    if (body) {
        msgHeaders[kHeaderContentLength] = [NSNumber numberWithLong:[body length]];
    }
    [self sendFrameWithCommand:kCommandSend
                       headers:msgHeaders
                          body:body];
}

- (STOMPSubscription *)subscribeTo:(NSString *)destination
                    messageHandler:(STOMPMessageHandler)handler {
    return [self subscribeTo:destination
                     headers:nil
              messageHandler:handler];
}

- (STOMPSubscription *)subscribeTo:(NSString *)destination
                           headers:(NSDictionary *)headers
                    messageHandler:(STOMPMessageHandler)handler {
    NSMutableDictionary *subHeaders = [[NSMutableDictionary alloc] initWithDictionary:headers];
    subHeaders[kHeaderDestination] = destination;
    NSString *identifier = subHeaders[kHeaderID];
    if (!identifier) {
        identifier = [NSString stringWithFormat:@"sub-%d", idGenerator++];
        subHeaders[kHeaderID] = identifier;
    }
    self.subscriptions[identifier] = handler;
    [self sendFrameWithCommand:kCommandSubscribe
                       headers:subHeaders
                          body:nil];
 
    STOMPSubscription*sub= [[STOMPSubscription alloc] initWithClient:self identifier:identifier subscriptionAddress:destination];
    
    return sub;
}

- (STOMPTransaction *)begin {
    NSString *identifier = [NSString stringWithFormat:@"tx-%d", idGenerator++];
    return [self begin:identifier];
}

- (STOMPTransaction *)begin:(NSString *)identifier {
    [self sendFrameWithCommand:kCommandBegin
                       headers:@{kHeaderTransaction: identifier}
                          body:nil];
    return [[STOMPTransaction alloc] initWithClient:self identifier:identifier];
}

- (void)disconnect {
    
    [self sendFrameWithCommand:kCommandDisconnect
                       headers:nil
                          body:nil];
    [self.subscriptions removeAllObjects];
    [self.pinger invalidate];
    [self.ponger invalidate];
    [self.socket close];
    
}
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
     self.socket=nil;
}
#pragma mark -
#pragma mark Private Methods

- (void)sendFrameWithCommand:(NSString *)command
                     headers:(NSDictionary *)headers
                        body:(NSString *)body {
    
    if (self.socket.readyState==SR_OPEN) {
        STOMPFrame *frame = [[STOMPFrame alloc] initWithCommand:command headers:headers body:body];
        [self.socket send:[frame toString]];
    }
   
    
}

- (void)checkPong{
    CFAbsoluteTime delta = CFAbsoluteTimeGetCurrent() - serverActivity;
    if (delta > 10) {
        DDLogInfo(@"checkPong did not receive server activity for the last %f seconds", delta);
        [self disconnect];
        if (self.delegate) {
            [self.delegate websocketDidDisconnectJFRWebSocket:socket error:nil];
        }
    }
}

/**
 设置心跳

 @param clientValues clientValues description
 @param serverValues serverValues description
 */
- (void)setupHeartBeatWithClient:(NSString *)clientValues
                          server:(NSString *)serverValues {
    NSInteger cx, cy, sx, sy;

    NSScanner *scanner = [NSScanner scannerWithString:clientValues];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@", "];
    [scanner scanInteger:&cx];
    [scanner scanInteger:&cy];

    scanner = [NSScanner scannerWithString:serverValues];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@", "];
    [scanner scanInteger:&sx];
    [scanner scanInteger:&sy];

    NSInteger pingTTL = ceil(MAX(cx, sy) / 1000);
    NSInteger pongTTL = ceil(MAX(sx, cy) / 1000);

    DDLogInfo(@"send heart-beat every %ld seconds", (long)pingTTL);
    DDLogInfo(@"expect to receive heart-beats every %ld seconds", (long)pongTTL);

//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (pingTTL > 0) {
////            self.pinger = [NSTimer scheduledTimerWithTimeInterval: pingTTL
////                                                           target: self
////                                                         selector: @selector(sendPing:)
////                                                         userInfo: nil
////                                                          repeats: YES];
//        }
//        if (pongTTL > 0) {
////            self.ponger = [NSTimer scheduledTimerWithTimeInterval: pongTTL
////                                                           target: self
////                                                         selector: @selector(checkPong:)
////                                                         userInfo: @{@"ttl": [NSNumber numberWithInteger:pongTTL]}
////                                                          repeats: YES];
//        }
//    });

}
-(void)setUpPongTimer{
    if (self.ponger) {
        [self.ponger invalidate];
        self.ponger=nil;
    }
    ///这个是为了判断最后一次收到心跳的时间和当前时间作比较
    self.ponger = [NSTimer scheduledTimerWithTimeInterval: 5  target: self  selector: @selector(checkPong)   userInfo: nil    repeats: YES];
//     [[NSRunLoop currentRunLoop] addTimer:self.ponger forMode:NSRunLoopCommonModes];
}
- (void)receivedFrame:(STOMPFrame *)frame {
    if([kCommandConnected isEqual:frame.command]) {
        self.connected = YES;
        [self setUpPongTimer];
        if (self.delegate) {
            [self.delegate webSocketDidConnect:frame];
        }
    } else if([kCommandMessage isEqual:frame.command]) {
        STOMPMessageHandler handler = self.subscriptions[frame.headers[kHeaderSubscription]];
        if (handler) {
            STOMPMessage *message = [STOMPMessage STOMPMessageFromFrame:frame client:self];
            handler(message);
        } 
    }  else if([kCommandError isEqual:frame.command]) {
        if (self.socket.readyState ==SR_OPEN) {
//            [self.socket close];
            [self disconnect ];
            NSError *error = [[NSError alloc] initWithDomain:@"StompKit" code:1 userInfo:@{@"frame": frame}];
            if (self.delegate ) {
                [self.delegate websocketDidDisconnectJFRWebSocket:socket error:error];
            }
        }
    } 
}
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSMutableDictionary *connectHeaders = [[NSMutableDictionary alloc] initWithDictionary:connectFrameHeaders];
    connectHeaders[kHeaderAcceptVersion] = kVersion1_2;
    if (!connectHeaders[kHeaderHost]) {
        connectHeaders[kHeaderHost] = host;
    }
    if (!connectHeaders[kHeaderHeartBeat]) {
        connectHeaders[kHeaderHeartBeat] = self.clientHeartBeat;
    } else {
        self.clientHeartBeat = connectHeaders[kHeaderHeartBeat];
    }

    [self sendFrameWithCommand:kCommandConnect
                       headers:connectHeaders
                          body: nil];
    
}
/// <#Description#>
/// @param webSocket <#webSocket description#>
/// @param message <#message description#>
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
//    DDLogInfo(@"webSocket=%@message=%@",webSocket,message);
    if ([message isKindOfClass:[NSString class]]) {
        if ([(NSString*)message isEqualToString:@"\n"]) {
            serverActivity = CFAbsoluteTimeGetCurrent();
            [self.socket send:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
        serverActivity = CFAbsoluteTimeGetCurrent();
        STOMPFrame *frame = [STOMPFrame STOMPFrameFromData:[message dataUsingEncoding:NSUTF8StringEncoding]];
            if (frame == nil || frame == NULL) {
            return;
        }
            [self receivedFrame:frame];
        }
    }  else if ([message isKindOfClass:[NSData class]]) {
        serverActivity = CFAbsoluteTimeGetCurrent();
           STOMPFrame *frame = [STOMPFrame STOMPFrameFromData:message];
           if (frame == nil || frame == NULL) {
               return;
           }
           [self receivedFrame:frame];
    }
   
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    if ([error isEqual:[NSNull null]]) {
        error=[[NSError alloc]init];
    }
    self.connected = NO;
    [self disconnect];
    if (self.delegate) {
        [self.delegate websocketDidDisconnectJFRWebSocket:socket error:error];
    }
}


@end
