//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "IcanTransferSelectBankCardHeadView.h"
#import "C2CCollectLegalTenderViewController.h"
@interface IcanTransferSelectBankCardHeadView()
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@end
@implementation IcanTransferSelectBankCardHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
//    "Pleaseentercurrency"="请输入法币";
//    "Alllegalcurrency"="全部法币";
    
    self.textField.placeholder =@"Pleaseenterbankname".icanlocalized;
    
}
-(void)searTextFieldDidChange{
    if (self.searchDidChangeBlock&&!self.textField.markedTextRange) {
        self.searchDidChangeBlock(self.textField.text);
    }
}
@end
