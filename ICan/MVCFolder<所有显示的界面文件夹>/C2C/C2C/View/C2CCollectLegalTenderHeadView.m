//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2CCollectLegalTenderHeadView.h"
@interface C2CCollectLegalTenderHeadView()
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@end
@implementation C2CCollectLegalTenderHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
//    "Pleaseentercurrency"="请输入法币";
//    "Alllegalcurrency"="全部法币";
    self.allLabel.text = @"YourFavoriteFiatCurrency".icanlocalized;
    self.textField.placeholder =@"Pleaseentercurrency".icanlocalized;
    
}

-(void)searTextFieldDidChange{
    if (self.searchDidChangeBlock&&!self.textField.markedTextRange) {
        self.searchDidChangeBlock(self.textField.text);
    }
}
@end
