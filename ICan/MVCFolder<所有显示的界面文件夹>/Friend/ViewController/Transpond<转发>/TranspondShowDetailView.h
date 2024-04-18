//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/10/2019
- File name:  TranspondDetailView.h
- Description: 点击完成之后显示的页面
- Function List:
*/
        

#import <UIKit/UIKit.h>
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface TranspondShowDetailView : UIView
/** 需要转发的用户  */
@property (nonatomic,strong) NSArray * userArr;
// 需要发送的message数组
@property (nonatomic, strong) NSMutableArray *selectMessageArray;
/// 转发的时候，用户手动输入的文字消息
@property (nonatomic, copy) void (^sendBlock) (ChatModel*textModel);
/// 用户取消转发
@property (nonatomic, copy) void (^cancleBlock)(void);
-(void)showTranspondDetailView;
@end

NS_ASSUME_NONNULL_END
