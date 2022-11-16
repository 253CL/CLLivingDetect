//
//  CLLivingSDKModel.m
//  CLLivingDetectSDK
//
//  Created by chuangLan on 2022/11/2.
//

#import "CLLivingSDKModel.h"
#import "CLLivingOperation.h"

@implementation CLLivingSDKModel

- (NSString *)certifyId{
    NSString * lastCertifyId = self.data[@"certifyId"];
    if(lastCertifyId.length > 0){
        return lastCertifyId;
    }
    return nil;
}

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if(dictionary && [dictionary isKindOfClass:[NSDictionary class]]){
        return [[self alloc] initWithDictionary:dictionary];
    }
    return nil;
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
- (id)valueForUndefinedKey:(NSString *)key{return nil;}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.code          forKey:@"code"];
    [aCoder encodeObject:self.message        forKey:@"message"];
    [aCoder encodeDouble:self.currentTime    forKey:@"currentTime"];
    [aCoder encodeInteger:self.vertityAction forKey:@"vertityAction"];
    [aCoder encodeObject:self.data           forKey:@"data"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.code          = [aDecoder decodeIntegerForKey:@"code"];
        self.message       = [aDecoder decodeObjectForKey:@"message"];
        self.currentTime   = [aDecoder decodeDoubleForKey:@"currentTime"];
        self.vertityAction = [aDecoder decodeIntegerForKey:@"vertityAction"];
        self.data          = [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}

- (void)cl_save{
    [[CLLivingOperation shareInstance].livingOperationLock lock];
    NSString * filePath = [CLLivingSDKModel getFilePath];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    [[CLLivingOperation shareInstance].livingOperationLock unlock];
//    CLLingDebugLog(@"【验证id缓存】保存：%@",self.data);
}

+ (CLLivingSDKModel *)cl_cacheModel{
    [[CLLivingOperation shareInstance].livingOperationLock lock];
    NSString * filePath = [CLLivingSDKModel getFilePath];
    CLLivingSDKModel * model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [[CLLivingOperation shareInstance].livingOperationLock unlock];
//    CLLingDebugLog(@"【验证id缓存】获取：%@",model.data);
    return model;
}

+ (void)cl_remove{
    [[CLLivingOperation shareInstance].livingOperationLock lock];
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * path = [CLLivingSDKModel getFilePath];
    BOOL result =NO;
    NSError * error;
    if([manager fileExistsAtPath:path]){
       result = [manager removeItemAtPath:path error:&error];
    }
    [[CLLivingOperation shareInstance].livingOperationLock unlock];
    CLLingDebugLog(@"【验证id缓存】移除：%@%@",result?@"成功":@"失败",error==nil?@"":error);
}

+ (NSString *)getFilePath {
    //获取Documents
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"CLLivingSDKModel"];
    return filePath;
}

@end
