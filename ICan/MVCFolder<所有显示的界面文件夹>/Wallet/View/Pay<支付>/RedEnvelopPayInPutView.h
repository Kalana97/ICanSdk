//
//  RedEnvelopPayInPutView.h
//  OneChatAPP
//  密码框view
//  Created by mac on 2017/2/8.
//  Copyright © 2017年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedEnvelopPayInPutView : UIControl

+ (instancetype)inputView;

@property (nonatomic,assign) NSInteger places;
@property (nonatomic,strong) UITextField *textField;
// 输入完成回调block
@property (nonatomic,copy) void(^RedEnvelopPayInPutViewDidCompletion)(NSString *text);

- (void)beginInput;
- (void)endInput;
- (void)clearInputInfo;

@end
