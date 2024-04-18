//
//  OrganizationHomeVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-20.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "OrganizationHomeVC.h"
#import "CreateOrganizationVC.h"

@interface OrganizationHomeVC ()

@property (weak, nonatomic) IBOutlet UILabel *createOrgLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIControl *nextControl;
@property (weak, nonatomic) IBOutlet UILabel *nextLbl;
@end

@implementation OrganizationHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create organization".icanlocalized;
    [self.nextControl layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    [self addLocalizations];
}

-(void)addLocalizations{
    self.createOrgLbl.text = @"Create organization".icanlocalized;
    self.descLbl.text = @"According your own business needs create your organization and accelerate the digitalization of business, and strengthening transaction security.".icanlocalized;
    self.nextLbl.text = @"NextStep".icanlocalized;
}

- (IBAction)goNextAction:(id)sender {
    CreateOrganizationVC *vc = [[CreateOrganizationVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
