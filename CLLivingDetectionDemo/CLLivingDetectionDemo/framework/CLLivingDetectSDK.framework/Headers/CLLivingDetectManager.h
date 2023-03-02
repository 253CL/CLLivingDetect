//
//  CLLivingDetectionManager.h
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/9/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class CLLivingResult;
@class CLLivingResponse;
@class CLLvingConfig;

@interface CLLivingDetectManager : NSObject
/// 初始化
/// @param appId 控制台创建应用的appid
+ (void)initWithAppId:(NSString *)appId;

/// 设置初始化超时时间，默认5.0f
/// @param timeout 超时时间设置
+ (void)setInitTimeout:(NSTimeInterval)timeout;

/// 参数配置
/// @param config config
+ (void)setLivingConfig:(CLLvingConfig *)config;

/// （可选方法）提前获取验证id（使用时需要在活体检测前提前1～2s调用），提高活体校验拉起速度（不建议app启动时调用）
+ (void)preGetVertyId;

/// 开启活体校验
/// @param viewController 当前显示viewcontroller
/// @param completion 返回结果
+ (void)startVerifyWithViewController:(UIViewController *)viewController
                            completion:(void(^)(CLLivingResult * result))completion;

/// 返回SDK版本号
+ (NSString *)getVersion;

/// 是否开启控制台日志打印
/// @param enable 默认为NO
+ (void)setPrintConsoleEnable:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
