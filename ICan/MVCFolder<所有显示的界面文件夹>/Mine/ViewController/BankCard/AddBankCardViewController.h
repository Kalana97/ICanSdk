//
//  AddBankCardViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/13.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "QDCommonViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface AddBankCardViewController : QDCommonViewController
@property(nonatomic, copy) void (^addBankCardSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
