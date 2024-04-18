//
//  ConfirmPopUp.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-08-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ConfirmPopUp.h"

@interface ConfirmPopUp ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@end

@implementation ConfirmPopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self lblChanges];
}

-(void)lblChanges{
    [self.noBtn setTitle:@"Cancel".icanlocalized forState:UIControlStateNormal];
    [self.yesBtn setTitle:@"Confirm".icanlocalized forState:UIControlStateNormal];

    if(self.type == 1){
        self.titleLbl.text = @"Reject Transaction".icanlocalized;
        self.descLbl.text = @"Confim to reject this transaction?".icanlocalized;
    }
    
    if(self.type == 2){
        self.titleLbl.text = @"Delete Level".icanlocalized;
        self.descLbl.text = @"Confirm to delete this level?".icanlocalized;
    }
}

-(void)setupUI{
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    self.yesBtn.layer.cornerRadius = 5;
    self.yesBtn.clipsToBounds = YES;
    self.noBtn.layer.cornerRadius = 5;
    self.noBtn.clipsToBounds = YES;
    
    // Add shadow
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor; // Shadow color
    self.bgView.layer.shadowOpacity = 0.5; // Shadow opacity
    self.bgView.layer.shadowRadius = 5; // Shadow radius
    self.bgView.layer.shadowOffset = CGSizeMake(0, 3); // Shadow offset
}

- (IBAction)didClose:(id)sender {
    if (self.noBlock) {
        self.noBlock();
    }
}

- (IBAction)didSelectNo:(id)sender {
    if (self.noBlock) {
        self.noBlock();
    }
}

- (IBAction)didSelectYes:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

@end
