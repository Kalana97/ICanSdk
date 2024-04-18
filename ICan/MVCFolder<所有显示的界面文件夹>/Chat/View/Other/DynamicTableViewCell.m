//
//  DynamicTableViewCell.m
//  ICan
//
//  Created by Kalana Rathnayaka on 04/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import "InsideDynamicViewTableViewCell.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif

@interface DynamicTableViewCell()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightWebview;
@property (weak, nonatomic) IBOutlet UIView *tebleViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImgContainer layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
    [self.headerImgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.webView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registNibWithNibName:kInsideDynamicListTableViewCell];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.headerImgView setUserInteractionEnabled:YES];
    [self.headerImgView addGestureRecognizer:tapGesture];

}
- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    if([self.infor.onclickFunction isEqualToString:@"NONE"]){
        return;
    }else if([self.infor.onclickFunction isEqualToString:@"OPEN_URL"]){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.isDynamicMessage = YES;
        NSString *url = self.infor.onclickData;
        View.dynamicMessageURL = url;
        View.hidesBottomBarWhenPushed = YES;
        NSNotification *notification = [NSNotification notificationWithName:@"Dynamic Message" object:View];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if([self.infor.onclickFunction isEqualToString:@"OPEN_APP"]){
        return;
    }else if([self.infor.onclickFunction isEqualToString:@"OPEN_HTML"]){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.isDynamicMessage = YES;
        View.htmlString = self.infor.onclickData;
        View.hidesBottomBarWhenPushed = YES;
        NSNotification *notification = [NSNotification notificationWithName:@"Dynamic Message" object:View];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}


-(void)setInfor:(DynamicMessageInfo *)infor {
    _infor = infor;
    if(infor.messageType == 1){
        self.webViewContainer.hidden = YES;
        if(infor.headerImgUrl == nil){
            self.headerImgContainer.hidden = YES;
        }else{
            self.headerImgContainer.hidden = NO;
            [self.headerImgView sd_setImageWithURL:[[NSURL alloc]initWithString:infor.headerImgUrl] placeholderImage:UIImageMake(@"thumbnail_default_placeholder")];
            self.title.text = infor.title;
            self.contentLabel.text = infor.messageData;
        }
    }else if(infor.messageType == 2){
        self.headerImgContainer.hidden = YES;
        if(infor.messageData != nil){
            self.webView.hidden = NO;
//            NSString *htmlString = @"<html><body><h1>Hello, World!</h1></body></html>";
//                NSString *htmlString = @"<!DOCTYPE html> <html> <head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> <style> body { font-family: Arial, sans-serif; height: 100; margin: 0; padding: 0; background-color: #f0f0f0;  } header { background-color: #333; color: #fff; text-align: center; padding: 20px; } .container { max-width: 1000px; max-height: 100px; margin: 0 auto; padding: 20px; } p { font-size: 18px; margin-bottom: 20px; } img { max-width: 100%; height: auto; display: block; margin: 0 auto; } </style> <title>Test</title> </head> <body> <header> <h1>Responsive Test Page</h1> </header> <div class=\"container\"> <p>\"Elementary, my dear Watson.\"</p> <img src=\"https://images.pexels.com/photos/60597/dahlia-red-blossom-bloom-60597.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1\" alt=\"Random Flower\"> </div> </body> </html>";
            [self.webView loadHTMLString:infor.messageData baseURL:nil];
        }
    }
    self.tableView.hidden = NO;
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    CGSize contentSize = webView.scrollView.contentSize;
    self.heightWebview.constant = contentSize.height;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"] && object == self.webView.scrollView) {
        CGSize contentSize = self.webView.scrollView.contentSize;
        self.heightWebview.constant = contentSize.height;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infor.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InsideDynamicViewTableViewCell *dataListCell = [tableView dequeueReusableCellWithIdentifier:kInsideDynamicListTableViewCell];
    NSArray *arry = self.infor.dataList;
    NSDictionary *dic = [arry objectAtIndex:indexPath.row];
    dataListCell.topic.text = dic[@"title"];
    NSString *imageUrlString = dic[@"imageUrl"];
    [dataListCell.imgView sd_setImageWithURL:dic[@"imageUrl"]];
//    NSURL *imageUrl;
//    if (![imageUrlString isKindOfClass:[NSNull class]]) {
//        imageUrl = [NSURL URLWithString:imageUrlString];
//    }
//        // Create an NSURLSessionDataTask to download the image data
//        NSURLSessionDataTask *imageDataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"Error downloading image: %@", error.localizedDescription);
//                return;
//            }
//            
//            if (data) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIImage *image = [UIImage imageWithData:data];
//                    if (image) {
//                        dataListCell.imgView.image = image;
//                    } else {
//                        NSLog(@"Invalid image data");
//                    }
//                });
//            }
//        }];
//        [imageDataTask resume];
//    this code snippest saved for future use
    dataListCell.imgView.contentMode = UIViewContentModeScaleAspectFill;
//    dataListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return dataListCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arry = self.infor.dataList;
    NSDictionary *dic = [arry objectAtIndex:indexPath.row];
    if([dic[@"onclickFunction"] isEqualToString:@"NONE"]){
        [self.tableView reloadData];
        return;
    }else if([dic[@"onclickFunction"] isEqualToString:@"OPEN_URL"]){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.isDynamicMessage = YES;
        View.dynamicMessageURL = dic[@"onclickData"];
        View.hidesBottomBarWhenPushed = YES;
        NSNotification *notification = [NSNotification notificationWithName:@"Dynamic Message" object:View];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if([dic[@"onclickFunction"] isEqualToString:@"OPEN_APP"]){
        [self.tableView reloadData];
        return;
    }else if([dic[@"onclickFunction"] isEqualToString:@"OPEN_HTML"]){
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.isDynamicMessage = YES;
        View.htmlString = dic[@"onclickData"];
        View.hidesBottomBarWhenPushed = YES;
        NSNotification *notification = [NSNotification notificationWithName:@"Dynamic Message" object:View];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    [self.tableView reloadData];
}

@end
