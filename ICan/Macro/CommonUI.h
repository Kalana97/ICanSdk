//
//  CommonUI.h
//  EasyPay
//
//  Created by 刘志峰 on 2019/4/22.
//  Copyright © 2019 EasyPay. All rights reserved.
///Users/dzl/Desktop/ican_ios/EasyPay/Macro/CommonUI.h

#ifndef CommonUI_h
#define CommonUI_h

#define hashEqual(str1,str2)  str1.hash == str2.hash  //hash码
/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

//frame
#define Frame(x,y,width,height)  CGRectMake(x, y, width, height)

//最大最小值
#define MaxX(frame) CGRectGetMaxX(frame)
#define MaxY(frame) CGRectGetMaxY(frame)
#define MinX(frame) CGRectGetMinX(frame)
#define MinY(frame) CGRectGetMinY(frame)
//宽度高度
#define Width(frame)    CGRectGetWidth(frame)
#define Height(frame)   CGRectGetHeight(frame)

#define  StatusBarAndNavigationBarHeight  (isIPhoneX ? 88.f : 64.f)
//加载本地图片
#define LoadImage(imageName) [UIImage imageNamed:imageName]

//设置字体
#define FontSet(fontSize)  [UIFont systemFontOfSize:fontSize]
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//基于6s适配宽高
#define KWidthRatio(R)  (R)*(ScreenWidth)/375
#define KHeightRatio(R)  (R)*(ScreenHeight)/667
//基于6s适配字体大小
#define TextFont(R) [UIFont systemFontOfSize:(R)*(ScreenWidth)/375]

/* iOS设备 */
#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)
//适配参数
//#define KsuitParam (kDevice_Is_iPhone6Plus ?1.12:(kDevice_Is_iPhone6?1.0:(iPhone6PlusBigMode ?1.01:0.85))) //以6s为基准图
#define KsuitParam ScreenWidth/375  //以6s为基准图

#pragma mark -- 适配iphoneX
// 判断是否是iPhone X
#define isIPhoneX (ScreenWidth >= 375.f && ScreenHeight >= 812.f && isIPhoneMobile)
#define isIPhoneMobile (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//// 状态栏高度
#define StatusBarHeight              (isIPhoneX ? 44.f : 20.f)
// 导航栏和状态栏高度
#define NavBarHeight                 (isIPhoneX ? 88.f : 64.f)
// tabBar高度
#define TabBarHeight                 (isIPhoneX ? (49.f + 34.f) : 49.f)
// home indicator
#define HomeIndicatorHeight          (isIPhoneX ? 34.f : 0.f)


//4s 5c 320
//6 3757
//414
#define KTextPadding    8
//55代表背景框和边距的距离
#define KTextMaxWidth  [UIScreen mainScreen].bounds.size.width - 55-10-70
//名片固定高度/宽度
#define KUserVCardButtonHeight 90
#define KUserVCardButtonWidth (190*ScreenWidth/320.0)
//朋友圈分享聊天固定宽度
#define KTimelineShareWidth 163
//位置固定宽度/高度
#define KLocationButtonHeight 135
#define KLocationButtonWidth  (190*ScreenWidth/320.0)

//位置固定宽度/高度
#define KShareGoodsHeight 180
#define KShareGoodsWidth  160

//视频固定宽度/高度
#define KVideoHeight 200
#define KVideoWidth  100

#define KFileButtonHeihgt 80
#define KFileButtonWidth  (190*ScreenWidth/320.0)



#define KRedEnvelpoeHeight 90
#define KRedEnvelopeWidth  (190*ScreenWidth/320.0)

//语音的高度
#define KVoiceFixHeight 40
//语音最大宽度
#define KVoiceMaxWidth 170
//固定边距
#define KFixedMargin  10
/** 自己发送的消息的cell 的内容距离右边已读提示的距离 */
#define KMineRightFixedMargin  10


#pragma mark - UI
// 屏幕相关
#define GK_SCREEN_WIDTH                 [UIScreen mainScreen].bounds.size.width
#define GK_SCREEN_HEIGHT                [UIScreen mainScreen].bounds.size.height
#define GK_SAFEAREA_TOP                 (GK_IS_iPhoneX ? 24.0f : 0.0f)   // 顶部安全区域
#define GK_SAFEAREA_BTM                 (GK_IS_iPhoneX ? 34.0f : 0.0f)   // 底部安全区域
#define GK_STATUSBAR_HEIGHT             (GK_IS_iPhoneX ? 44.0f : 20.0f)  // 状态栏高度
#define GK_NAVBAR_HEIGHT                44.0f   // 导航栏高度
#define GK_STATUSBAR_NAVBAR_HEIGHT      (GK_STATUSBAR_HEIGHT + GK_NAVBAR_HEIGHT) // 状态栏+导航栏高度
#define GK_TABBAR_HEIGHT                (GK_IS_iPhoneX ? 83.0f : 49.0f)  //tabbar高度

// 判断是否是iPhone X系列
#define GK_IS_iPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)

// 屏幕宽高
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

// 适配比例
#define ADAPTATIONRATIO     SCREEN_WIDTH / 375.0f

// 导航栏高度与tabbar高度
#define NAVBAR_HEIGHT       (IS_iPhoneX ? 88.0f : 64.0f)
#define TABBAR_HEIGHT       (IS_iPhoneX ? 83.0f : 49.0f)

// 状态栏高度
#define STATUSBAR_HEIGHT    (IS_iPhoneX ? 44.0f : 20.0f)

// 判断是否是iPhone X系列
#define IS_iPhoneX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)

// 颜色
#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)
#define GKColorGray(v)          GKColorRGB(v, v, v)

#define GKColorHEX(hexValue, a) GKColorRGBA(((float)((hexValue & 0xFF0000) >> 16)), ((float)((hexValue & 0xFF00) >> 8)), ((float)(hexValue & 0xFF)), a)

#define GKColorRandom           GKColorRGB(arc4random() % 255, arc4random() % 255, arc4random() % 255)

#define HEXCOLOR(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0  blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

// 来自YYKit
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif
#endif /* CommonUI_h */
