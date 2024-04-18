//
//  APRTransactionCell.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-10.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "APRTransactionCell.h"
#import "JKPickerView.h"

@implementation APRTransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(QTPermission *)permissionModel{
    [self.bgCell layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.nameLbl.text = @"Approve Transactions".icanlocalized;
    if(![permissionModel.data isEqualToString:@""] && permissionModel.data != nil){
        self.transactionLvlLbl.text = [NSString stringWithFormat:@"%@ %@",@"Level".icanlocalized,permissionModel.data];
    }
}

- (IBAction)didTapCell:(id)sender {
    if(self.memberInfo.userType != 1){
        [self showOptionView];
    }
}

-(void)showOptionView{
    // Assuming you have an NSInteger count with a value of 3
    NSInteger count = self.organizationInfoModel.transactionApprovalLevels;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"No Level".icanlocalized];
    for (NSInteger i = 1; i <= count; i++) {
        NSString *level = [NSString stringWithFormat:@"%@ %ld",@"Level".icanlocalized,(long)i];
        if(i != 1){
            [array addObject:level];
        }
    }
    [[JKPickerView sharedJKPickerView]setPickViewWithTarget:self title:@"Level Type" leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:array dataBlock:^(NSString* obj) {
        NSString *title = (NSString *)obj;
        if (self.tapBlock) {
            if([title isEqualToString:@"No Level".icanlocalized]){
                self.tapBlock(title);
            }else{
                NSString *pattern = @"\\d+";
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
                NSTextCheckingResult *result = [regex firstMatchInString:title options:0 range:NSMakeRange(0, title.length)];
                NSString *numericPart = [title substringWithRange:result.range];
                self.tapBlock(numericPart);
            }
        }
    }];
}

- (void)removePick {
    [[JKPickerView sharedJKPickerView] removePickView];
}

- (void)sureAction {
    [[JKPickerView sharedJKPickerView] sureAction];
}
@end
