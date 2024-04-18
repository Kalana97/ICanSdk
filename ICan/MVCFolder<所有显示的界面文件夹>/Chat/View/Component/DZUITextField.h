//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 10/6/2021
- File name:  DZUITextField.h
- Description:
- Function List:
*/
        

#import "QMUITextField.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DZUITextFieldDelegate <QMUITextFieldDelegate>
@property(nonatomic, assign)  int floatLenth;

@end
@interface DZUITextField : QMUITextField
@property(nonatomic, weak) id<DZUITextFieldDelegate> delegate;
/**
 *  小数点后面保留多少位
 */
@property(nonatomic, assign) IBInspectable int floatLenth;
@end

NS_ASSUME_NONNULL_END
