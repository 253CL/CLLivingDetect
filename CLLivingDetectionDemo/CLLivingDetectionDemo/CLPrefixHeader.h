//
//  CLPrefixHeader.h
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/10/27.
//

#ifndef CLPrefixHeader_h
#define CLPrefixHeader_h

#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import <CLConsole/CLConsole.h>

#define WeakSelf(type) __weak __typeof__(type) weakSelf = type;
#define StrongSelf(type) __strong __typeof__(type) strongSelf = type;

#define HexColor(colorStrin) [UIColor colorWithHexString:colorStrin]

#define CL_Screen_Width        [UIScreen mainScreen].bounds.size.width   /// 屏幕屏宽
#define CL_Screen_Height       [UIScreen mainScreen].bounds.size.height   /// 屏幕屏高

#define statusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define CL_IS_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define CL_StatusBar_Height    (CL_IS_iPhoneX ? (44.0):(20.0))
#define CL_NavBar_Height       (44.0)
#define CL_Nav_Height          (CL_StatusBar_Height + CL_NavBar_Height)
#define CL_Bottom_SafeHeight   (CL_IS_iPhoneX ? (34.0):(0))
#define CL_TabBar_Height       (49.0 + CL_Bottom_SafeHeight)
#define CL_SearchBar_Height    (55)

#define kCLUIAdapter(v)              (v*(CL_Screen_Width / 375))              /// 尺寸适配
#define KCLUIHeightAdapter(v)        (v*(CL_Screen_Height /675))

#define UIColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]
#define UIColorFromHex(hexValue)        UIColorFromHexA(hexValue, 1.0f)

#define bottomCopyRightText         @"© 2022 创蓝文化"
#define imageViewWidth              (300 * KWidthScale)
// 传入imageView的宽高比应为3:4
#define imageViewHeight             (imageViewWidth * 4 / 3)
#define cameraViewRadius            (130 * KWidthScale)



#endif /* CLPrefixHeader_h */
