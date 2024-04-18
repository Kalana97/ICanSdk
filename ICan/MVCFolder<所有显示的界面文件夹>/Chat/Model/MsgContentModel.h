//
//  MsgContentModel.h
//  ICan
//
//  Created by MAC on 2023-03-01.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgContentModel: NSObject
@property(nonatomic, retain) NSString *pinnedMsgId;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, retain) NSString *audience;
@property(nonatomic, assign) BOOL isUnpinAll;
@end
