//
//  GoBottomActionView.m
//  ICan
//
//  Created by apple on 15/11/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "GoBottomActionView.h"

@interface GoBottomActionView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation GoBottomActionView

- (void)viewDidLoad {
//    [super viewDidLoad];
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 20;
    
    self.bgView.layer.shadowColor = UIColor.grayColor.CGColor;
    //阴影偏移
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.bgView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgView.layer.shadowRadius = 5;
    
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
