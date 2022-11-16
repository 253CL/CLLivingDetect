//
//  CLLivingOperation.h
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/10/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLLvingConfig.h"

NS_ASSUME_NONNULL_BEGIN

#define CLDebugLog(fmt, ...) if([CLLivingOperation shareInstance].debugLog) \
CLLivingLoger((@"💧💧💧%s" "(%d)\n" fmt "\n") , __FUNCTION__, __LINE__, ##__VA_ARGS__);\

#define CLLingDebugLog(fmt, ...) {if([CLLivingOperation shareInstance].isPrint) \
CLLivingLoger((@"💧💧💧" fmt "\n") , ## __VA_ARGS__);}\


#define CLLivingLoger(format, ...) {\
NSString *logoInfo = [NSString stringWithFormat:format , ##__VA_ARGS__];\
NSLog(format, ##__VA_ARGS__);\
[[NSNotificationCenter defaultCenter] postNotificationName:@"CLLivingLogPrintMessage" object: [NSString stringWithFormat:@"%@ function:%s,file:%s,line:%d,time:%s %s \n%@",[NSThread currentThread],__PRETTY_FUNCTION__,__FILE_NAME__,__LINE__,__DATE__,__TIME__,logoInfo]];\
}



@class CLLivingResponse;
@class CLLivingResult;
@class CLLivingSDKModel;
@interface CLLivingOperation : NSObject

@property (nonatomic, strong)NSString * appId;

@property (nonatomic, assign)BOOL isPrint;
@property (nonatomic, assign)int  debugLog;

@property (nonatomic,   weak)UIViewController * weakVC;
@property (nonatomic, strong)NSString         * SDKVersion;

@property (nonatomic, assign)double lastRequestTime;
@property (nonatomic, strong)NSString * deviceToken;

/// 初始化超时时间
@property (nonatomic, assign)NSTimeInterval initTimeout;
///产品类型 0:实人认证
@property (nonatomic, strong)NSString * productType;
///客户端类型  1  ios   2 android
@property (nonatomic, strong)NSString * client;

@property NSRecursiveLock * livingOperationLock;

+ (instancetype)shareInstance;

- (void)initWithAppId:(NSString *)appId
           completion:(void(^)(CLLivingResult * result))completion;

- (void)setCustomConfig:(CLLvingConfig *)config;

- (void)startVerifyWithViewController:(UIViewController *)viewController
                           completion:(void(^)(CLLivingResult * result))completion;

- (void)getCertifyIdCompletion:(void(^)(NSError * _Nonnull error, CLLivingSDKModel * model))completion;

- (void)startLivingDetectWithCertifyId:(NSString *)certifyId
                        viewcontroller:(UIViewController *)viewcontroller
                            completion:(void(^)(CLLivingResult * result))completion;

@end

NS_ASSUME_NONNULL_END
