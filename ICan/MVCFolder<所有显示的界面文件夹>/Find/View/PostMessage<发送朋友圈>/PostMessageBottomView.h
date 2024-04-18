//
//  PostMessageBottomView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
// 发布帖子的底部的View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, PostMessageFunctionType) {
    PostMessageFunctionType_photograph=0,
    PostMessageFunctionType_image,
    PostMessageFunctionType_face,
    PostMessageFunctionType_atUser,
    PostMessageFunctionType_location,
};
@interface PostMessageBottomView : UIView
@property(nonatomic,copy) void(^tapBlock)(PostMessageFunctionType type);
@property(nonatomic, assign) BOOL isInputView;
-(instancetype)initWithFrame:(CGRect)frame isInputView:(BOOL)isInputView;
@end

NS_ASSUME_NONNULL_END
