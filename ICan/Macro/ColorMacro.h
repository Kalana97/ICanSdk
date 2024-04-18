//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 23/9/2019
- File name:  ColorMacro.h
- Description:
- Function List:
*/
        

#ifndef ColorMacro_h
#define ColorMacro_h
//16进制颜色
#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]
//颜色转换
#define UIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorMakeWithAlpha(r, g, b, l) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:l]
/**
 *    生成二进制颜色
 *    @param     rgbValue     颜色描述字符串，带“0x”开头
 *    @return    UIColor对象
// 16进制颜色 */
#define UIColorMakeHEXCOLOR(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

///ICan
#ifdef ICANTYPE

//一个很淡的背景颜色 作用在tabbar的背景颜色下面
#define UIColorBg243Color UIColorMake(243, 243, 243)
//主题色
#define UIColorThemeMainColor UIColorMake(57, 116, 246) //1D81F5

#define  UIColor244RedColor UIColorMake(244, 81, 105) //F45169
//分割线颜色
#define UIColorSeparatorColor UIColorMake(243, 243, 243)//F3F3F3

#define UIColor252730Color UIColorMake(25, 27, 30) //191B1E

#define UIColor153Color UIColorMake(153, 153, 153) //999999
#define UIColor102Color UIColorMake(102, 102, 102) //666666
#define UIColor238Color UIColorMake(238, 238, 238) //EEEEEE
#define UIColorBlackColor UIColorMake(0, 0, 0) //EEEEEE

//导航栏的中间文字颜色 191B1E
#define UIColorNavBarTitleColor UIColorMake(25, 27, 30) //191B1E
//导航栏的背景颜色
#define UIColorNavBarBarTintColor [UIColor whiteColor]
//也即导航栏上面的按钮颜色
//165,170,180
#define UIColorNavBarTintColor UIColorMake(25, 27, 30)
#define KButtonAbleColor UIColorMake(29, 129, 245)

#define YXMainColor UIColorMake(232, 58, 29)

//tabbar背景颜色
#define UIColorTabBarBgColor [UIColor whiteColor]
//View背景颜色
#define UIColorViewBgColor [UIColor whiteColor]
//tabbar字体颜色
#define UIColorTabBarTitleColor UIColorMake(25, 27, 30)
//主题背景色
#define UIColorThemeMainBgColor [UIColor whiteColor]

//主题字体色
#define UIColorThemeMainTitleColor UIColorMakeHEXCOLOR(0x191B1E)

//主题二级字体色
#define UIColorThemeMainSubTitleColor UIColorMakeHEXCOLOR(0x999999)

//导航栏返回按钮颜色
#define UIColorNavBarBackColor     [UIColor blackColor]

//搜索框的背景颜色
#define UIColorSearchBgColor UIColorMake(243, 243, 243)

//10px间隙背景颜色
#define UIColor10PxClearanceBgColor UIColorMake(243, 243, 243)


//聊天左侧汽包的背景颜色
#define UIColorChatLeftBgColor UIColorMakeHEXCOLOR(0xF3F3F3)
//聊天左侧字体颜色
#define UIColorChatLeftTextColor UIColorMakeHEXCOLOR(0x191B1E)

//聊天右侧汽包的背景颜色
#define UIColorChatRightBgColor UIColorMakeHEXCOLOR(0x0b82ff)
//聊天右侧字体颜色
#define UIColorChatRightTextColor UIColorMakeHEXCOLOR(0xffffff)

#define UIColorSystemGreen UIColorMake(52, 199, 89)
#define UIColorSystemRed UIColorMake(255, 99, 48)
#define UIColorPasswordBoarder UIColorMake(255, 60, 60)
#define UIColorPasswordBg UIColorMake(246, 240, 240)

#endif

///ICan
#ifdef ICANCNTYPE

//一个很淡的背景颜色 作用在tabbar的背景颜色下面
#define UIColorBg243Color UIColorMake(243, 243, 243)
//主题色
#define UIColorThemeMainColor UIColorMake(29, 129, 245) //1D81F5

#define  UIColor244RedColor UIColorMake(244, 81, 105) //F45169
//分割线颜色
#define UIColorSeparatorColor UIColorMake(243, 243, 243)//F3F3F3

#define UIColor252730Color UIColorMake(25, 27, 30) //191B1E

#define UIColor153Color UIColorMake(153, 153, 153) //999999
#define UIColor102Color UIColorMake(102, 102, 102) //666666
#define UIColor238Color UIColorMake(238, 238, 238) //EEEEEE
//导航栏的中间文字颜色 191B1E
#define UIColorNavBarTitleColor UIColorMake(25, 27, 30) //191B1E
//导航栏的背景颜色
#define UIColorNavBarBarTintColor [UIColor whiteColor]
//也即导航栏上面的按钮颜色
//165,170,180
#define UIColorNavBarTintColor UIColorMake(25, 27, 30)
#define KButtonAbleColor UIColorMake(29, 129, 245)

#define YXMainColor UIColorMake(232, 58, 29)

#define UIColorSystemGreen UIColorMake(52, 199, 89)
#define UIColorSystemRed UIColorMake(255, 99, 48)

//tabbar背景颜色
#define UIColorTabBarBgColor [UIColor whiteColor]
//View背景颜色
#define UIColorViewBgColor [UIColor whiteColor]
//tabbar字体颜色
#define UIColorTabBarTitleColor UIColorMake(25, 27, 30)

//主题背景色
#define UIColorThemeMainBgColor [UIColor whiteColor]

//主题字体色
#define UIColorThemeMainTitleColor UIColorMakeHEXCOLOR(0x191B1E)

//主题二级字体色
#define UIColorThemeMainSubTitleColor UIColorMakeHEXCOLOR(0x999999)

//导航栏返回按钮颜色
#define UIColorNavBarBackColor     [UIColor blackColor]

//搜索框的背景颜色
#define UIColorSearchBgColor UIColorMake(243, 243, 243)

//10px间隙背景颜色
#define UIColor10PxClearanceBgColor UIColorMake(243, 243, 243)


//聊天左侧汽包的背景颜色
#define UIColorChatLeftBgColor UIColorMakeHEXCOLOR(0xF3F3F3)
//聊天左侧字体颜色
#define UIColorChatLeftTextColor UIColorMakeHEXCOLOR(0x191B1E)

//聊天右侧汽包的背景颜色
#define UIColorChatRightBgColor UIColorMakeHEXCOLOR(0x0b82ff)
//聊天右侧字体颜色
#define UIColorChatRightTextColor UIColorMakeHEXCOLOR(0xffffff)

#define UIColorPasswordBoarder UIColorMake(255, 60, 60)
#define UIColorPasswordBg UIColorMake(246, 240, 240)
#endif


#endif /* ColorMacro_h */
