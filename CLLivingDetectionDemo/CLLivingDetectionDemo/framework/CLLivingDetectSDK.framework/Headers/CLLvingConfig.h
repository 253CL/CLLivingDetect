//
//  CLLvingConfig.h
//  CLLivingDetectSDK
//
//  Created by chuangLan on 2022/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CLLivingVerifyActionLiveness = 1,    //（默认）眨眼动作活体检测
    CLLivingVerifyActionMulti,           //多动作活体检测,眨眼+任意摇头检测
} CLLivingVerifyAction;


@interface CLLvingConfig : NSObject

/// 扫脸圆圈颜色，默认为蓝色，颜色格式为 @"#FFFFFF"
@property(nonatomic, strong) NSString * faceCircleColor;

/// 验证请求超时时间设置
@property(nonatomic, strong) NSNumber * vertifyOutTime;

/// 是否返回图片，默认为@(NO)
@property(nonatomic, strong)NSNumber * returnImage;

/// 是否返回录制视频地址，默认不返回，格式@(YES) or @(NO)
@property(nonatomic, assign) NSNumber * returnVideo;

/// 活体检测动作
///（默认）眨眼动作活体检测；
/// CLLivingVertifyActionMulti：多动作活体检测，眨眼+任意摇头检测
@property(nonatomic, assign) CLLivingVerifyAction vertifyAction;

///是否自定义协议，默认为@(YES),显示协议页 ，为@(NO)需要用户自定义协议页面
@property(nonatomic, assign)NSNumber * showProtocol;

+ (CLLvingConfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
