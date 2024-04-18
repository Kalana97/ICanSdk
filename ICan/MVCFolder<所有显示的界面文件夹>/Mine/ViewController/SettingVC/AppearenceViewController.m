//
//  AppearenceViewController.m
//  ICan
//
//  Created by Kalana Rathnayaka on 27/06/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "AppearenceViewController.h"
#import "JKPickerView.h"
#import "SelectBackgroundViewController.h"

@interface AppearenceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *selectedSize;
@property (weak, nonatomic) IBOutlet UILabel *setFontSize;
@property (weak, nonatomic) IBOutlet UILabel *setChatWallpaper;

@end

@implementation AppearenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.setFontSize.text = @"SetFontSize".icanlocalized;
    self.setChatWallpaper.text = @"setChatWallpaper".icanlocalized;
    self.navigationItem.title = @"Appearance".icanlocalized;
    self.selectedSize.text = UserInfoManager.sharedManager.selectedFont;
    if([UserInfoManager.sharedManager.selectedFont isEqual:@"Small"]){
        self.selectedSize.text = @"Small".icanlocalized;
    }else if ([UserInfoManager.sharedManager.selectedFont isEqual:@"Default"]){
        self.selectedSize.text = @"Default".icanlocalized;
    }else if ([UserInfoManager.sharedManager.selectedFont isEqual:@"Large"]) {
        self.selectedSize.text = @"Large".icanlocalized;
    }else {
        self.selectedSize.text = @"Default".icanlocalized;
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)changeFontSize:(id)sender {
    [self showPickView];
}

- (IBAction)changeChatWallpaper:(id)sender {
    SelectBackgroundViewController * vc = [SelectBackgroundViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)showPickView{
    @weakify(self);
    NSInteger row;
    NSArray *dataArray = @[@"Small".icanlocalized,@"Default".icanlocalized,@"Large".icanlocalized];
    if([self.selectedSize.text isEqual:@"Default"]){
        row = [dataArray indexOfObject:@"Default".icanlocalized];
    }else if ([self.selectedSize.text isEqual:@"Small"]){
        row = [dataArray indexOfObject:@"Small".icanlocalized];
    }else if ([self.selectedSize.text isEqual:@"Large"]){
        row = [dataArray indexOfObject:@"Large".icanlocalized];
    }
    [[JKPickerView sharedJKPickerView] setPickViewWithTarget:self title:@"SetFontSize".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:dataArray dataBlock:^(NSString *title) {
        @strongify(self);
        self.selectedSize.text = title;
        if([title isEqual:@"Default".icanlocalized]) {
            UserInfoManager.sharedManager.fontSize = @"17";
        }else if([title isEqual:@"Small".icanlocalized]) {
            UserInfoManager.sharedManager.fontSize = @"16";
        }else if([title isEqual:@"Large".icanlocalized]) {
            UserInfoManager.sharedManager.fontSize = @"19";
        }
        UserInfoManager.sharedManager.selectedFont = title;
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}
-(void)removePick{
    [[JKPickerView sharedJKPickerView] removePickView];
}
-(void)sureAction{
    [[JKPickerView sharedJKPickerView] sureAction];
}
@end
