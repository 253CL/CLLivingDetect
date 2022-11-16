//
//  Tool.h
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CLKeyCircleColor   @"CLKeyCircleColor"
#define CLkeyActionSetting @"CLkeyActionSetting"


@interface CLTool : NSObject
+ (NSString *)getTimeStamp;
+ (NSMutableString *)formatStringFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)secretLoginAndMachineCheckuuidString;
+ (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharacters:(NSString *)string;
+ (NSString *)secretLoginAndMachineCheckhmacsha1:(NSString *)text key:(NSString *)secret;
+ (nullable NSString *)md5:(nullable NSString *)str;

/// 颜色转换
+(NSString *)hexadecimalFromUIColor: (UIColor*) color;
+ (UIColor *)getRandomColor;
+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

/// 本地存储
+ (void)saveData:(id)data key:(NSString *)key;
+ (void)removeData:(id)data key:(NSString *)key;
+ (id)getDataForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
