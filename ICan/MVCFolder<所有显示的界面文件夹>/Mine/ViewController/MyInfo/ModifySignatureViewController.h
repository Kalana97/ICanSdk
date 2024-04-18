//
//  ModifySignatureViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/3.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModifySignatureViewController : BaseViewController
@property(nonatomic,copy) void(^modifySucessBlock)(void);
@end

NS_ASSUME_NONNULL_END
