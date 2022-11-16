//
//  CLLivingDetectionManager.m
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/9/28.
//

#import "CLLivingDetectManager.h"
#import <UIKit/UIKit.h>
#import <AliyunIdentityManager/AliyunIdentityPublicApi.h>
#import "CLLivingNetWorking.h"
#import "CLLivingOperation.h"
#import "CLLivingResult.h"
#import "CLLvingConfig.h"

@implementation CLLivingDetectManager

+ (void)initWithAppId:(NSString *)appId{
    CLLingDebugLog(@"【当前SDK版本号】：%@",[self getVersion]);
    if(appId.length == 0){
        CLLingDebugLog(@"【初始化】：appId不能为空");
        return;
    }
    CLLingDebugLog(@"【初始化】：appId：%@",appId);
    [AliyunSdk init];
    [CLLivingOperation shareInstance].appId = appId;
    [[CLLivingOperation shareInstance] initWithAppId:appId completion:^(CLLivingResult * _Nonnull result) {
    }];
}

+ (id)metainfo{
    return [AliyunIdentityManager getMetaInfo];
}

+ (NSString *)getVersion{
    return [CLLivingOperation shareInstance].SDKVersion;
}

#pragma mark - setter
+ (void)setInitTimeout:(NSTimeInterval)timeout{
    [CLLivingOperation shareInstance].initTimeout = timeout;
}

+ (void)setLivingConfig:(CLLvingConfig *)config{
    [[CLLivingOperation shareInstance] setCustomConfig:config];
}

+ (void)setPrintConsoleEnable:(BOOL)enable{
    [CLLivingOperation shareInstance].isPrint = enable;
//    [CLLivingOperation shareInstance].debugLog = enable;
}


#pragma mark - request
+ (void)startVerifyWithViewController:(UIViewController *)viewController
                            completion:(void(^)(CLLivingResult * result))completion{

    [[CLLivingOperation shareInstance] startVerifyWithViewController:viewController completion:completion];
}


////---------------------------------------------内部调试
+ (void)getCertifyIdWithParameters:(NSDictionary *)parameters
                        completion:(void(^)(NSError * _Nonnull error, NSDictionary * _Nonnull data))completion{
    [[CLLivingOperation shareInstance] getCertifyIdCompletion:^(NSError * _Nonnull error, CLLivingSDKModel * _Nonnull model) {
        
    }];
}

+ (void)startLivingDetectWithCertifyId:(NSString *)certifyId viewcontroller:(UIViewController *)viewcontroller completion:(void(^)(CLLivingResult * result))completion{
    
    if(certifyId.length ==0){
        CLLingDebugLog(@"certtifyId=%@,不能为空",certifyId);
        return;
    }
    
    if(viewcontroller == nil){
        CLLingDebugLog(@"viewcontroller = %@",@"请检查传递的viewcontroller");
        return;
    }
    
    [[CLLivingOperation shareInstance] startLivingDetectWithCertifyId:certifyId viewcontroller:viewcontroller completion:^(CLLivingResult * _Nonnull result) {
        
        NSString *title = @"刷脸成功";
        switch (result.code) {
            case 1000:
                break;
            case 1003:
                title = @"用户退出";
                break;
            case 2002:
                title = @"网络错误";
                break;
            case 2006:
                title = @"刷脸失败";
                break;
             case 2003:
                title = @"设备时间不准确";
                break;
            default:
                break;
     }
        NSLog(@"输出信息：response.retMessageSub");
        completion(result);
    }];
}

@end
