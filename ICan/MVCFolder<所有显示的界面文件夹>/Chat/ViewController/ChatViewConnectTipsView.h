//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 25/8/2020
- File name:  ChatViewConnectTipsView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewConnectTipsView : UIView
@property(nonatomic, assign) SocketConnectStatus status;
-(void)loginStart;
-(void)loginSuccess;
-(void)loginFailed;
 -(void)noNet;
@end

NS_ASSUME_NONNULL_END
