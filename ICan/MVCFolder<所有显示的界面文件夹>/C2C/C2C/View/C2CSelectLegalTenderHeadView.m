//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2CSelectLegalTenderHeadView.h"
#import "C2CCollectLegalTenderViewController.h"
@interface C2CSelectLegalTenderHeadView()
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@property (weak, nonatomic) IBOutlet UILabel *collectLab;
@end
@implementation C2CSelectLegalTenderHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
//    "Pleaseentercurrency"="请输入法币";
//    "Alllegalcurrency"="全部法币";
    self.allLabel.text = @"Alllegalcurrency".icanlocalized;
    self.textField.placeholder =@"Pleaseentercurrency".icanlocalized;
    self.collectLab.text = @"mine.listView.cell.collect".icanlocalized;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.collectLab addGestureRecognizer:tap];
    
}
-(void)tap{
    !self.tapBlock?:self.tapBlock();
    
}
-(void)searTextFieldDidChange{
    if (self.searchDidChangeBlock&&!self.textField.markedTextRange) {
        self.searchDidChangeBlock(self.textField.text);
    }
}
@end
