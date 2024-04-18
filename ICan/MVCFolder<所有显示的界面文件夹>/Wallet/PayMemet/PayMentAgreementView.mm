

//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 3/9/2020
 - File name:  PayMentAgreementView.m
 - Description:
 - Function List:
 */


#import "PayMentAgreementView.h"
#import <WebKit/WebKit.h>
#import "PayMentAgreementViewCell.h"
@interface PayMentAgreementView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) UILabel *tipsLabel;
@property(nonatomic, strong) UIButton *agreeButton;
@property(nonatomic, strong) UIButton *refuseButton;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation PayMentAgreementView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.2);
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.tipsLabel];
        //        [self.bgView addSubview:self.webView];
        [self.bgView addSubview:self.tableView];
        [self.bgView addSubview:self.agreeButton];
        [self.bgView addSubview:self.refuseButton];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(@(ScreenWidth-60));
            make.height.equalTo(@(KHeightRatio(500)));
        }];
        
        
        [self.refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@-10);
            make.height.equalTo(@45);
            make.right.equalTo(@-30);
            make.left.equalTo(@30);
        }];
        [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.refuseButton.mas_top).offset(-10);
            make.height.equalTo(@45);
            make.right.equalTo(@-30);
            make.left.equalTo(@30);
        }];
        
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@30);
        }];
        
        //        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.equalTo(@-30);
        //            make.left.equalTo(@30);
        //            make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        ////            make.top.equalTo(@0);
        //            make.bottom.equalTo(self.agreeButton.mas_top).offset(-25);
        //        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.left.equalTo(@0);
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
            //            make.top.equalTo(@0);
            make.bottom.equalTo(self.agreeButton.mas_top).offset(-25);
        }];
        
        
    }
    return self;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        _bgView.backgroundColor=UIColor.whiteColor;
        [_bgView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    }
    return _bgView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registNibWithNibName:kPayMentAgreementViewCell];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1        ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayMentAgreementViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kPayMentAgreementViewCell];
    return cell;
}


-(WKWebView *)webView{
    if (!_webView) {
        _webView=[[WKWebView alloc]init];
        //        NSURLRequest*request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.woxingapp.com/qrcode"]];
        NSString*path;
        if (BaseSettingManager.isChinaLanguages) {
            path=[[NSBundle mainBundle]pathForResource:@"receive" ofType:@"txt"];
        }else{
            path =[[NSBundle mainBundle]pathForResource:@"receive_en" ofType:@"txt"];
        }
       
        NSString*url=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:url baseURL:nil];
        //        [_webView loadRequest:request];
    }
    return _webView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel centerLabelWithTitle:@"Payment Agreement".icanlocalized font:16 color:UIColor252730Color];
    }
    return _tipsLabel;
}
-(UIButton *)agreeButton{
    if (!_agreeButton) {
        _agreeButton=[UIButton dzButtonWithTitle:@"I Agree".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:14 titleColor:UIColor.whiteColor target:self action:@selector(agreeButtonAction)];
        [_agreeButton layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    }
    return _agreeButton;
}
-(void)agreeButtonAction{
    self.hidden=YES;
    UserConfigurationInfo*info=[BaseSettingManager sharedManager].userConfigurationInfo;
    info.isAgreePayment=YES;
    [BaseSettingManager sharedManager].userConfigurationInfo=info;
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}

-(UIButton *)refuseButton{
    if (!_refuseButton) {
        _refuseButton=[UIButton dzButtonWithTitle:@"Let me think again".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColor153Color target:self action:@selector(refuseButtonAction)];
    }
    return _refuseButton;
}
-(void)refuseButtonAction{
    [self removeFromSuperview];
    self.hidden=YES;
}
@end
