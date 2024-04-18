//
//  DynamicChatModel.h
//  ICan
//
//  Created by Kalana Rathnayaka on 05/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicChatModel : NSObject
//dynamic message type
@property(nonatomic, assign) NSInteger messageType;
@property(nonatomic, assign) NSInteger languageCode;
@property(nonatomic, copy) NSString *headerImgUrl;
@property(nonatomic, copy) NSString *messageData;
@property(nonatomic, copy) NSString *onclickFunction;
@property(nonatomic, copy) NSString *onclickData;
@property(nonatomic, copy) NSString *merchantId;
@property(nonatomic, copy) NSString *sender;
@property(nonatomic, copy) NSString *senderImgUrl;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSArray *dataList;
@end

NS_ASSUME_NONNULL_END
