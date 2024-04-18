//
//  AddAdressTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/18.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "AddAdressTableViewCell.h"

@interface AddAdressTableViewCell ()<UITextFieldDelegate>



@end

@implementation AddAdressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = UIColor102Color;
    self.textFeild.textColor =UIColor102Color;
    self.textFeild.backgroundColor=UIColor.whiteColor;
    self.textFeild.borderStyle = UITextBorderStyleNone;
    self.textFeild.delegate=self;

}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    !self.tapBlock?:self.tapBlock();
    return self.canEdit;
}


-(void)setTextFeildPlacehoderText:(NSString *)textFeildPlacehoderText{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = UIColor153Color;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:textFeildPlacehoderText attributes:dict];
    self.textFeild.attributedPlaceholder =attr;
    
}




@end
