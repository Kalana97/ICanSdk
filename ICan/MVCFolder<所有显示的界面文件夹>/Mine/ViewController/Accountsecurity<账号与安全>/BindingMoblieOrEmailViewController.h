//
//  BindingMoblieOrEmailViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/3.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,BindingType) {
    BindingType_Moblie,//绑定手机
    BindingType_Email,//绑定邮箱
  
};

@interface BindingMoblieOrEmailViewController : BaseViewController
@property (nonatomic,assign) BindingType  bindingType;
@end

NS_ASSUME_NONNULL_END
