//
//  CLLivingOperation.m
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/10/12.
//

#import "CLLivingOperation.h"
#import <AliyunIdentityManager/AliyunIdentityPublicApi.h>
#import <AliyunIdentityManager/AliyunIdentityManager.h>
#import "CLLivingNetWorking.h"
#import "CLLivingResult.h"
#import "CLLivingSDKModel.h"
#import <objc/runtime.h>

#define CLLivingSDKVersion @"1.0.0"
#define CLLivingCacheTime  (15*60)

@interface CLLivingOperation ()
@property (nonatomic, strong)CLLvingConfig    * livingConfig;
@end

@implementation CLLivingOperation

+ (instancetype)shareInstance{
    static CLLivingOperation * operation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operation = [[self alloc] init];
    });
    return operation;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.lastRequestTime = 0.0f;
        self.initTimeout = 5.0f;
        self.productType = @"0";
        self.client      = @"1";
        self.livingOperationLock = [[NSRecursiveLock alloc] init];
        self.livingOperationLock.name = @"com.living.lock.operation";
        
        self.isPrint = NO;
        self.debugLog= NO;
    }
    return self;
}

- (void)initWithAppId:(NSString *)appId completion:(void(^)(CLLivingResult * result))completion{
    if(appId == nil || appId.length ==0){
        CLLivingResult * res = [[CLLivingResult alloc] initWithCode:1002 message:@"appId错误" ext:nil error:[NSError errorWithDomain:@"appId错误" code:1002 userInfo:nil]];
        completion(res);
        return;
    }
}

/// 获取缓存id，判断是否有值
- (CLLivingSDKModel *)checkoutCacheCertifyId{
    CLLivingSDKModel * model = [CLLivingSDKModel cl_cacheModel];
    if(!model || model.certifyId==nil){
        CLLingDebugLog(@"【缓存取号】：无缓存");
        return nil;
    }
    
    if([[CLLivingTool getCurrentTime] doubleValue] - model.currentTime > CLLivingCacheTime){
        CLLingDebugLog(@"【缓存取号】：缓存已过期");
        return nil;
    }
    
    if(model.vertityAction != self.livingConfig.vertifyAction){
        CLLingDebugLog(@"【缓存取号】：缓存已失效，用户更改设置");
        return nil;
    }
    return model;
}
#pragma mark - request
- (void)startVerifyWithViewController:(UIViewController *)viewController
                            completion:(void(^)(CLLivingResult * result))completion{
    
    NSTimeInterval sdkInitOutTime = [[CLLivingOperation shareInstance].livingConfig.vertifyOutTime doubleValue] +0.5;
    dispatch_queue_t queue = dispatch_queue_create("www.clliving.sdk.com", DISPATCH_QUEUE_SERIAL);
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block CLLivingResult *res = nil;
    __block NSString * certifyId= @"";
    
    dispatch_async(queue, ^{
        [self getCertifyIdCompletion:^(NSError * _Nonnull error, CLLivingSDKModel * _Nonnull model) {
            if(error){
                res = [[CLLivingResult alloc] initWithCode:10003 message:@"请求异常" ext:nil error:[NSError errorWithDomain:error.localizedDescription code:error.code userInfo:error.userInfo]];
                [res fillPropertyInfo];
            }else{
                
                if(model.code == 200000){
                    certifyId =  model.certifyId;
                }else{
                    res = [[CLLivingResult alloc] initWithCode:10002 message:@"验签失败" ext:nil error:[NSError errorWithDomain:model.message code:model.code userInfo:nil]];
                }
            }
            dispatch_semaphore_signal(sem);
        }];
    });
        
    dispatch_async(queue, ^{
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sem,dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sdkInitOutTime * NSEC_PER_SEC)));
        if(certifyId.length > 0){
            [self startLivingDetectWithCertifyId:certifyId viewcontroller:viewController completion:^(CLLivingResult * _Nonnull result) {
                completion(result);
            }];
        }else{
            if(!res){
                res = [[CLLivingResult alloc] initWithCode:10003 message:@"请求超时" ext:nil error:[NSError errorWithDomain:@"请求超时" code:1023 userInfo:nil]];
            }
            completion(res);
        }
    });
}

- (void)getCertifyIdCompletion:(void(^)(NSError * _Nonnull error, CLLivingSDKModel * model))completion{
        
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    NSString * URLString = [NSString stringWithFormat:@"%@%@",CLLivingBaseURLString,CLLivingInitURLQuery];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    NSDictionary * dic = [AliyunIdentityManager getMetaInfo];
    
    NSString * metaInfo    = [self dictionaryToStringWithDictionary:dic];
    NSString * appId       = self.appId;
    NSString * client      = self.client;
    NSString * productType = self.productType;
    NSString * version     = [self SDKVersion];
    NSString * bundleId    = [CLLivingTool getBundleId];
    NSString * timeStap    = [CLLivingTool getTimeStamp];
    NSString * model       = self.livingConfig.vertifyAction ==1?@"LIVENESS":@"MULTI_ACTION";
    
    [param setValue:appId       forKey:@"appId"];
    [param setValue:version     forKey:@"version"];
    [param setValue:client      forKey:@"client"];
    [param setValue:productType forKey:@"productType"];
    [param setValue:bundleId    forKey:@"bundleId"];
    [param setValue:model       forKey:@"model"];
    [param setValue:timeStap    forKey:@"timeStamp"];
    [param setValue:metaInfo    forKey:@"metaInfo"];
    
    NSMutableString *formDataString = [self formatStringFromDictionary:param];
    NSString * signStr = [CLLivingTool secretLoginAndMachineCheckhmacsha1:formDataString key:[CLLivingTool md5:appId]];
    param[@"sign"] = signStr;
//    param[@"sign"] = [CLLivingTool stringByAddingPercentEncodingWithAllowedCharacters:signStr];
        
    CLLivingSDKModel * cacheModel = [self checkoutCacheCertifyId];
    if(cacheModel){
        NSTimeInterval end = CFAbsoluteTimeGetCurrent();
        CLLingDebugLog(@"【获取验证id请求耗时】(缓存)%.1fs",end-start);
        NSError * error = nil;
        completion(error,cacheModel);
    }else{
        NSTimeInterval  timeout = [self.livingConfig.vertifyOutTime floatValue];
        [CLLivingNetWorking requestInitWithURLString:URLString timeInterval:timeout parameters:param completion:^(id  _Nonnull data, NSError * _Nullable error) {
            NSTimeInterval end = CFAbsoluteTimeGetCurrent();
            CLLingDebugLog(@"【获取验证id请求】（请求）请求耗时：%.1fs\n请求结果：%@",end-start,error==nil?data:error)
            CLLivingSDKModel * model = [CLLivingSDKModel initWithDictionary:data];
            if(!error && !model){
                error = [NSError errorWithDomain:@"返回数据无法解析" code:-999 userInfo:nil];
            }
            
            if(model.code == 200000){
                model.currentTime = [[CLLivingTool getCurrentTime] doubleValue];
                model.vertityAction = [CLLivingOperation shareInstance].livingConfig.vertifyAction;
                [model cl_save];
            }
            completion(error,model);
        }];
    }
}

- (void)startLivingDetectWithCertifyId:(NSString *)certifyId viewcontroller:(UIViewController *)viewcontroller completion:(void(^)(CLLivingResult * result))completion{
    
    NSMutableDictionary  *extParams = [NSMutableDictionary new];
    [extParams setValue:viewcontroller forKey:kZIMCurrentViewControllerKey];
      
    //扫脸圈颜色
    if(self.livingConfig.faceCircleColor.length >0){
        [extParams setValue:self.livingConfig.faceCircleColor forKey:ZIM_EXT_PARAMS_KEY_OCR_FACE_CIRCLE_COLOR];
    }
    
    //是否返回视频地址
    if ([self.livingConfig.returnVideo boolValue]) {
        [extParams setValue:@"true" forKey:ZIM_EXT_PARAMS_KEY_USE_VIDEO];
    }else{
        [extParams setValue:@"false" forKey:ZIM_EXT_PARAMS_KEY_USE_VIDEO];
    }
    
    CLLingDebugLog(@"【活体校验】开始.........");
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    [[AliyunIdentityManager sharedInstance] verifyWith:certifyId extParams:extParams onCompletion:^(ZIMResponse *response) {
        
        
        [CLLivingSDKModel cl_remove];
        BOOL hasImage = [[CLLivingOperation shareInstance].livingConfig.returnImage boolValue];
        CLLivingDetectResponse * resp = [CLLivingDetectResponse initWithData:response image:hasImage];
        resp.certifyId = certifyId;
        resp.videoFilePath = response.videoFilePath;
        CLLivingResult * formatResult = [CLLivingResult initWithResponse:resp];
        [formatResult fillPropertyInfo];
        
        NSTimeInterval end = CFAbsoluteTimeGetCurrent();
        CLLingDebugLog(@"【活体校验】：验证耗时：%.1f\n验证id：%@\n请求参数：%@\n请求结果：\n{code:%@,\nmessage:%@,\ninnerCode:%@,\ninnerMessage:%@,\ncertifyId:%@,\nvideoFilePath:%@,\nimageContent:%@}",end-start,certifyId,extParams,@(formatResult.code),formatResult.message,@(formatResult.innerCode),formatResult.innerMessage,formatResult.response.certifyId,formatResult.response.videoFilePath,formatResult.response.imageContent);
        
        CLLingDebugLog(@"【活体校验】结束.........")
        completion(formatResult);
    }];
}

#pragma mark - setter or getter
- (void)setLivingConfig:(CLLvingConfig *)livingConfig{
    _livingConfig = livingConfig;
}

//- (void)setIsPrint:(BOOL)isPrint{
//    _isPrint = isPrint;
//    if(isPrint==YES) self.debugLog = NO;
//}
//
//- (void)setDebugLog:(int)debugLog{
//    _debugLog = debugLog;
//    if(debugLog==YES) self.isPrint =NO;
//}

- (NSString *)SDKVersion{
    return CLLivingSDKVersion;
}

- (void)setCustomConfig:(CLLvingConfig *)config{
    self.livingConfig = config;
    
    CLLivingSDKModel * model = [self checkoutCacheCertifyId];
    if(model && [[CLLivingTool getCurrentTime] doubleValue] - model.currentTime < CLLivingCacheTime && model.certifyId && model.vertityAction == self.livingConfig.vertifyAction){
    }else{
        [self getCertifyIdCompletion:^(NSError * _Nonnull error, CLLivingSDKModel * _Nonnull model) {}];
    }
}

#pragma mark -private
- (NSString *)dictionaryToStringWithDictionary:(NSDictionary *)dictionary{
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];

    NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSDictionary *)convertToDictWithObject:(NSObject *)object{//获取当前对象的所有属性以及属性的值
    NSMutableDictionary *Dict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    //获取所有属性以及属性的值,并且转换为一个字典
    for (i = 0; i<outCount; i++){
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [object valueForKey:(NSString *)propertyName];
        if (propertyValue) [Dict setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return Dict;
}


- (NSMutableString *)formatStringFromDictionary:(NSDictionary *)dictionary{
    NSMutableString *formDataString = [NSMutableString new];
    NSArray * keys = [dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * objString1 = [NSString stringWithFormat:@"%@",obj1];
        NSString * objString2 = [NSString stringWithFormat:@"%@",obj2];
        return [objString1 compare:objString2];
    }];
    for (NSString * key in keys) {
        [formDataString appendString:key];
        [formDataString appendString:dictionary[key]];
    }
    return formDataString;
}




@end
