//
//  CLLivingResult.m
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/10/12.
//

#import "CLLivingResult.h"
#import "CLLivingNetWorking.h"
#import <AliyunIdentityManager/AliyunIdentityManager.h>

typedef enum : NSUInteger {
    CLLivingResponseSuccess     = 1000, //人脸比对成功
    CLLivingResponseError       = 1001, //用户被动退出
    CLLivingResponseInterrupt   = 1003, //用户主动退出
    CLLivingResponseNetworkfail = 2002, //网络失败
    CLLivingResponseTimeError   = 2003, //设备时间设置不对
    CLLivingResponseFail        = 2006  //服务端validate失败
} CLLivingResponseCode;

@interface CLLivingDetectResponse ()

@property(nonatomic, assign, readwrite)CLLivingResponseCode innerCode;
@property(nonatomic, assign, readwrite)CLLivingResponseCode retCode;
@property(nonatomic, copy, readwrite)NSString * reason;
@property(nonatomic, copy, readwrite)NSString * retCodeSub;
@property(nonatomic, copy, readwrite)NSString * retMessageSub;

@property(nonatomic, strong, readwrite)NSDictionary * _Nullable extInfo;
@property(nonatomic, strong, readwrite)NSString * _Nullable bizData;


@end

@implementation CLLivingDetectResponse

+ (instancetype)initWithData:(id)data image:(BOOL)image{
    ZIMResponse * response = (ZIMResponse *)data;
    if(data && [data isKindOfClass:[ZIMResponse class]]){
        return [[CLLivingDetectResponse alloc] initWithResponseCode:(CLLivingResponseCode)response.code
                                                            retCode:(CLLivingResponseCode)response.retCode
                                                         retCodeSub:response.retCodeSub
                                                      retMessageSub:response.retMessageSub
                                                             reason:response.reason
                                                       imageContent:image?response.imageContent:nil
                                                           extParam:response.extInfo
                                                            bizData:response.bizData];
    }
    return nil;
}

- (instancetype)initWithResponseCode:(CLLivingResponseCode)code
                             retCode:(CLLivingResponseCode)retCode
                          retCodeSub:(NSString * _Nullable)retCodeSub
                       retMessageSub:(NSString * _Nullable)retMessageSub
                              reason:(NSString * _Nullable)reason
                        imageContent:(nonnull NSData *)imageData
                            extParam:(NSDictionary * _Nullable)extInfo
                             bizData:(NSString * _Nullable)bizData{
    self = [super init];
    if (self) {
        self.innerCode       = code;
        self.retCode         = retCode;
        self.retCodeSub      = retCodeSub;
        self.retMessageSub   = retMessageSub;
        self.reason          = reason;
        self.extInfo         = extInfo.copy;
        self.bizData         = bizData;
        self.imageContent    = imageData;
    }
    return self;
}
@end





@interface CLLivingResult()
@property(nonatomic, assign, readwrite)NSInteger  code;
@property(nonatomic, strong, readwrite)NSString * message;
@property(nonatomic, strong, readwrite)NSError  * error;
@end

@implementation CLLivingResult

- (instancetype)initWithResult:(NSInteger)code message:(NSString *)message{
    self = [super init];
    if(self){
        self.code = code;
        self.message    = message;
    }
    return self;
}

+ (instancetype)initWithResponse:(CLLivingDetectResponse *)response{
    
    CLLivingResult * result = [[CLLivingResult alloc] init];
    result.response = response;
    
    NSDictionary * codeDic = [result codeDescription];
    if(response.innerCode == 1000){
        result.code = 10000;
        result.message = @"刷脸成功";
        result.innerCode    = response.innerCode;
        result.innerMessage = codeDic[response.retCodeSub];
        if(result.innerMessage.length==0){
            result.innerMessage = response.reason;
        }
    }else{
        result.code = 10001;
        result.message = @"校验失败";
        result.innerCode = response.innerCode;
        result.innerMessage = codeDic[response.retCodeSub];
        if(result.innerMessage.length==0){
            result.innerMessage = response.reason;
        }
    }
    return result;
}


- (instancetype)initWithCode:(NSInteger)code
                     message:(NSString *)message
                         ext:(id)ext
                       error:(NSError *)error{
    self = [super init];
    if(self){
        self.code    = code;
        self.message = message;
        self.ext     = ext;
        self.error   = error;
    }
    return self;
}

- (NSDictionary *)codeDescription{
    return @{@"Z5120":@"刷脸成功，认证通过。可通过服务端查询接口获取认证详细资料信息",
             @"Z1000":@"抱歉，系统出错了，请您稍后再试",
             @"Z1001":@"拒绝开通相机权限",
             @"Z1002":@"无法启动相机",
             @"Z1005":@"刷脸超时(单次)",
             @"Z1006":@"多次刷脸超时",
             @"Z1007":@"本地活体检测出错",
             @"Z1009":@"验证中断（用户点击home键等导致验证停止）",
             @"Z1010":@"业务参数错误",
             @"Z1147":@"本地活体检测出错",
             @"Z1146":@"本地活体检测出错",
             @"Z1008":@"用户主动退出认证",
             @"Z2001":@"用户OCR主动退出",
             @"2002" :@"网络错误",
             @"Z5128":@"刷脸失败，认证未通过。可通过服务端查询接口获取认证详细资料信息",
             @"2006":@"刷脸失败，认证未通过。可通过服务端查询接口获取认证未通过具体原因"
    };
}

-(void)fillPropertyInfo{
    @try {
        if(self.innerMessage == nil){
            if (self.error) {
                //解析内层码
                NSNumber * getInnerCode = [CLLivingTool clCodeWithError:self.error];
                if (getInnerCode != nil) {
                    self.innerCode = getInnerCode.integerValue;
                }
                //解析内层描述放到外层描述
                NSString * getResDesc = [CLLivingTool clDescripetionWithError:self.error];
                if (getResDesc != nil) {
                    self.innerMessage = getResDesc;
                }
                NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]initWithDictionary:self.error.userInfo];
                userInfo[@"obj"] = nil;
                userInfo[@"object"] = nil;
                if (userInfo.count > 0) {
                    NSString * failUrl = userInfo[@"NSErrorFailingURLKey"];
                    NSString * failLocalizedDescription = userInfo[@"NSLocalizedDescription"];
                    
                    if (failUrl && failLocalizedDescription) {
                        self.innerMessage = [NSString stringWithFormat:@"%@",failLocalizedDescription];
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%s,CatchException:name:%@\n reason:%@\n userInfo:%@\n",__func__,exception.name,exception.reason,exception.userInfo);
    }
}


@end

