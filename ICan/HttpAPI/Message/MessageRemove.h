//
//  MessageRemove.h
//  ICan
//
//  Created by MAC on 2023-08-04.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageRemove : BaseRequest
@property(nonatomic, strong, nullable) NSArray *messageIds;
@end

NS_ASSUME_NONNULL_END
