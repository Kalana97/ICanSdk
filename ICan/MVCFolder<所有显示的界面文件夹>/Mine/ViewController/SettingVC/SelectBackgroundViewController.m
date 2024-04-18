//
//  SelectBackgroundViewController.m
//  ICan
//
//  Created by Kalana Rathnayaka on 29/06/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "SelectBackgroundViewController.h"

@interface SelectBackgroundViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;
@property (weak, nonatomic) IBOutlet UIImageView *img7;
@property (weak, nonatomic) IBOutlet UIImageView *img8;
@property (weak, nonatomic) IBOutlet UIImageView *img9;
@property (weak, nonatomic) IBOutlet UILabel *dLabel;
@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinkLabel;
@property (nonatomic,strong) NSString *name;
@property (weak, nonatomic) IBOutlet UILabel *defaultLable;
@property (weak, nonatomic) IBOutlet UIImageView *prevImg;
@property (weak, nonatomic) IBOutlet UIImageView *btn1;
@property (weak, nonatomic) IBOutlet UIImageView *btn2;
@property (weak, nonatomic) IBOutlet UIImageView *btn3;
@property (weak, nonatomic) IBOutlet UIImageView *btn4;
@property (weak, nonatomic) IBOutlet UIImageView *btn5;
@property (weak, nonatomic) IBOutlet UIImageView *btn6;
@property (weak, nonatomic) IBOutlet UIImageView *btn7;
@property (weak, nonatomic) IBOutlet UIImageView *btn8;
@property (weak, nonatomic) IBOutlet UIImageView *btn9;
@property (weak, nonatomic) IBOutlet UILabel *setWallpaperLaabel;


@end

@implementation SelectBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"ChatWallpaper".icanlocalized;
    // Enable user interaction on the image view
    self.dLabel.text = @"Default".icanlocalized;
    self.pLabel.text = @"Purple".icanlocalized;
    self.gLabel.text = @"Green".icanlocalized;
    self.pinkLabel.text = @"Pink".icanlocalized;
    self.setWallpaperLaabel.text = @"Select Your wallpaper".icanlocalized;
    self.defaultLable.text = @"Default Wallpaper".icanlocalized;
    
    if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper1"]){
        self.btn1.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 1"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper2"]){
        self.btn2.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 2"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper3"]){
        self.btn3.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 3"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper4"]){
        self.btn4.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 4"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper5"]){
        self.btn5.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 5"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper6"]){
        self.btn6.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 6"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper7"]){
        self.btn7.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 7"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper8"]){
        self.btn8.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 8"];
    }else if([UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper9"]){
        self.btn9.hidden = NO;
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 9"];
    }else {
        self.prevImg.image = [UIImage imageNamed:@"chatwallpaper0"];
    }
    
    self.img1.userInteractionEnabled = YES;
    self.img2.userInteractionEnabled = YES;
    self.img3.userInteractionEnabled = YES;
    self.img0.userInteractionEnabled = YES;
    self.img4.userInteractionEnabled = YES;
    self.img5.userInteractionEnabled = YES;
    self.img6.userInteractionEnabled = YES;
    self.img7.userInteractionEnabled = YES;
    self.img8.userInteractionEnabled = YES;
    self.img9.userInteractionEnabled = YES;
    self.defaultLable.userInteractionEnabled = YES;
    
    self.img1.layer.borderWidth = 0.3;
    self.img2.layer.borderWidth = 0.3;
    self.img3.layer.borderWidth = 0.3;
    self.img0.layer.borderWidth = 0.3;
    self.img4.layer.borderWidth = 0.3;
    self.img5.layer.borderWidth = 0.3;
    self.img6.layer.borderWidth = 0.3;
    self.img7.layer.borderWidth = 0.3;
    self.img8.layer.borderWidth = 0.3;
    self.img9.layer.borderWidth = 0.3;
//    self.prevImg.layer.borderWidth = 0.3;
    
    self.img0.layer.cornerRadius = 10;
    self.img1.layer.cornerRadius = 10;
    self.img2.layer.cornerRadius = 10;
    self.img3.layer.cornerRadius = 10;
    self.img4.layer.cornerRadius = 10;
    self.img5.layer.cornerRadius = 10;
    self.img6.layer.cornerRadius = 10;
    self.img7.layer.cornerRadius = 10;
    self.img8.layer.cornerRadius = 10;
    self.img9.layer.cornerRadius = 10;
    self.prevImg.layer.cornerRadius = 10;
    
    self.img0.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img5.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img6.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img7.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img8.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.img9.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.prevImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.img0.layer.masksToBounds = YES;
    self.img1.layer.masksToBounds = YES;
    self.img2.layer.masksToBounds = YES;
    self.img3.layer.masksToBounds = YES;
    self.img4.layer.masksToBounds = YES;
    self.img5.layer.masksToBounds = YES;
    self.img6.layer.masksToBounds = YES;
    self.img7.layer.masksToBounds = YES;
    self.img8.layer.masksToBounds = YES;
    self.img9.layer.masksToBounds = YES;
    self.prevImg.layer.masksToBounds = YES;
    
    self.btn1.layer.cornerRadius = 10;
    self.btn1.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 10;
    self.btn2.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 10;
    self.btn3.layer.masksToBounds = YES;
    self.btn4.layer.cornerRadius = 10;
    self.btn4.layer.masksToBounds = YES;
    self.btn5.layer.cornerRadius = 10;
    self.btn5.layer.masksToBounds = YES;
    self.btn6.layer.cornerRadius = 10;
    self.btn6.layer.masksToBounds = YES;
    self.btn7.layer.cornerRadius = 10;
    self.btn7.layer.masksToBounds = YES;
    self.btn8.layer.cornerRadius = 10;
    self.btn8.layer.masksToBounds = YES;
    self.btn9.layer.cornerRadius = 10;
    self.btn9.layer.masksToBounds = YES;

    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped1:)];
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped2:)];
    UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped3:)];
    UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped4:)];
    UITapGestureRecognizer *tapGestureRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped5:)];
    UITapGestureRecognizer *tapGestureRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped6:)];
    UITapGestureRecognizer *tapGestureRecognizer7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped7:)];
    UITapGestureRecognizer *tapGestureRecognizer8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped8:)];
    UITapGestureRecognizer *tapGestureRecognizer9 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped9:)];
    
    UITapGestureRecognizer *tapGestureRecognizerLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapped:)];

    // Add the tap gesture recognizer to the image view
    [self.img1 addGestureRecognizer:tapGestureRecognizer1];
    [self.img2 addGestureRecognizer:tapGestureRecognizer2];
    [self.img3 addGestureRecognizer:tapGestureRecognizer3];
    [self.img4 addGestureRecognizer:tapGestureRecognizer4];
    [self.img5 addGestureRecognizer:tapGestureRecognizer5];
    [self.img6 addGestureRecognizer:tapGestureRecognizer6];
    [self.img7 addGestureRecognizer:tapGestureRecognizer7];
    [self.img8 addGestureRecognizer:tapGestureRecognizer8];
    [self.img9 addGestureRecognizer:tapGestureRecognizer9];
    [self.defaultLable addGestureRecognizer:tapGestureRecognizerLabel];


}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Apply the clicking effect when touch begins
    self.img0.alpha = 0.5; // Set the desired alpha value or apply any other effect
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Remove the clicking effect when touch ends
    self.img0.alpha = 1.0; // Set the original alpha value or revert the effect
}

- (void)buttonTapped:(id)sender {
    [QMUITipsTool showLoadingWihtMessage:@"Updating..".icanlocalized inView:self.view isAutoHidden:YES];
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper10";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper0"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}

- (void)imageViewTapped1:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper1";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 1"];
    self.btn1.hidden = NO;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
    
}
- (void)imageViewTapped2:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper2";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 2"];
    self.btn1.hidden = YES;
    self.btn2.hidden = NO;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped3:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper3";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 3"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = NO;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped4:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper4";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 4"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = NO;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped5:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper5";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 5"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = NO;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped6:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper6";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 6"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = NO;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped7:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper7";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 7"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = NO;
    self.btn8.hidden = YES;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped8:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper8";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 8"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = NO;
    self.btn9.hidden = YES;
}
- (void)imageViewTapped9:(UITapGestureRecognizer *)gestureRecognizer {
    // Handle the tap event
    UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper9";
    self.prevImg.image = [UIImage imageNamed:@"chatwallpaper9 9"];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.btn7.hidden = YES;
    self.btn8.hidden = YES;
    self.btn9.hidden = NO;
}

@end
