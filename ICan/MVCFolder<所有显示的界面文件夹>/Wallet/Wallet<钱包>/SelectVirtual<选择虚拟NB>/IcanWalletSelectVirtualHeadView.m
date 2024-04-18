//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelectVirtualHeadView.h"
@interface IcanWalletSelectVirtualHeadView()
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelLab;

@end
@implementation IcanWalletSelectVirtualHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
//    "Listofcurrencies"="币种列表";
//    "keywordtosearch"="请输入关键字搜索";
    self.allLabel.text = @"Listofcurrencies".icanlocalized;
    self.textField.placeholder =@"keywordtosearch".icanlocalized;
    self.cancelLab.text = @"Cancel".icanlocalized;
}
-(void)searTextFieldDidChange{
    if (self.searchDidChangeBlock&&!self.textField.markedTextRange) {
        self.searchDidChangeBlock(self.textField.text);
    }
}
- (IBAction)cancelActioon {
    !self.cancelBlcok?:self.cancelBlcok();
}
@end
