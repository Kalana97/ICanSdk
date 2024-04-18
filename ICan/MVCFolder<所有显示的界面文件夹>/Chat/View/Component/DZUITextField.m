
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 10/6/2021
 - File name:  DZUITextField.m
 - Description:
 - Function List:
 */


#import "DZUITextField.h"
#import "NSObject+QMUIMultipleDelegates.h"
#import "QMUICore.h"
#import "NSString+QMUI.h"
#import "UITextField+QMUI.h"
#import "QMUIMultipleDelegates.h"
@interface _DZUITextFieldDelegator : NSObject <DZUITextFieldDelegate, UIScrollViewDelegate>

@property(nonatomic, weak) DZUITextField *textField;
@end

@interface DZUITextField ()

@property(nonatomic, strong) _DZUITextFieldDelegator *delegator;
@end

@implementation DZUITextField
@dynamic delegate;
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self didInitialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}
-(void)setFloatLenth:(int)floatLenth{
    _floatLenth = floatLenth;
    self.delegator.floatLenth = floatLenth;
}
- (void)didInitialize {
    self.qmui_multipleDelegatesEnabled=YES;
    self.delegator = [[_DZUITextFieldDelegator alloc] init];
    self.floatLenth = 2;
    self.maximumTextLength = 1000;
    self.delegator.textField = self;
    self.delegate = self.delegator;
    
}
- (NSUInteger)lengthWithString:(NSString *)string {
    return self.shouldCountingNonASCIICharacterAsTwo ? string.qmui_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
}
- (void)fireTextDidChangeEventForTextField:(QMUITextField *)textField {
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField];
}
@end
@implementation _DZUITextFieldDelegator
- (BOOL)textField:(DZUITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.maximumTextLength < NSUIntegerMax) {
        
        // 如果是中文输入法正在输入拼音的过程中（markedTextRange 不为 nil），是不应该限制字数的（例如输入“huang”这5个字符，其实只是为了输入“黄”这一个字符），所以在 shouldChange 这里不会限制，而是放在 didChange 那里限制。
        if (textField.markedTextRange) {
            return YES;
        }
        
        BOOL isDeleting = range.length > 0 && string.length <= 0;
        if (isDeleting) {
            if (NSMaxRange(range) > textField.text.length) {
                // https://github.com/Tencent/QMUI_iOS/issues/377
                return NO;
            } else {
                return YES;
            }
        }
        
        NSUInteger rangeLength = textField.shouldCountingNonASCIICharacterAsTwo ? [textField.text substringWithRange:range].qmui_lengthWhenCountingNonASCIICharacterAsTwo : range.length;
        if ([textField lengthWithString:textField.text] - rangeLength + [textField lengthWithString:string] > textField.maximumTextLength) {
            // 将要插入的文字裁剪成这么长，就可以让它插入了
            NSInteger substringLength = textField.maximumTextLength - [textField lengthWithString:textField.text] + rangeLength;
            if (substringLength > 0 && [textField lengthWithString:string] > substringLength) {
                NSString *allowedText = [string qmui_substringAvoidBreakingUpCharacterSequencesWithRange:NSMakeRange(0, substringLength) lessValue:YES countingNonASCIICharacterAsTwo:textField.shouldCountingNonASCIICharacterAsTwo];
                if ([textField lengthWithString:allowedText] <= substringLength) {
                    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:allowedText];
                    
                    if (!textField.shouldResponseToProgrammaticallyTextChanges) {
                        [textField fireTextDidChangeEventForTextField:textField];
                    }
                }
            }
            
            if ([textField.delegate respondsToSelector:@selector(textField:didPreventTextChangeInRange:replacementString:)]) {
                [textField.delegate textField:textField didPreventTextChangeInRange:range replacementString:string];
            }
            return NO;
        }
    }
    
    // 删除数据, 都允许删除
    if (range.length >= 1) {
        return YES;
    }
    if (![self checkDecimal:[textField.text stringByAppendingString:string]]){
        if (textField.text.length > 0 && [string isEqualToString:@"."] && ![textField.text containsString:@"."]) {
            return YES;
        }
        return NO;
    }
    return YES;
}
- (BOOL)checkDecimal:(NSString *)str{
    NSString *regex = [NSString stringWithFormat:@"^[0-9]+(\\.[0-9]{1,%d})?$",self.floatLenth];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [pred evaluateWithObject: str];
}
@synthesize floatLenth;

@end
