//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 25/10/2019
- File name:  QRCodeView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,QRCodeViewTyep) {
    QRCodeViewTyep_user=0,//个人二维码
    QRCodeViewTyep_group,//群二维码
};
NS_ASSUME_NONNULL_BEGIN

@interface QRCodeView : UIView
-(void)showQRCodeView;
-(void)hiddenQRCodeView;

@property (nonatomic,assign)  QRCodeViewTyep qrCodeViewTyep;


@property (nonatomic,strong) GroupListInfo *groupDetailInfo;


@end

NS_ASSUME_NONNULL_END
