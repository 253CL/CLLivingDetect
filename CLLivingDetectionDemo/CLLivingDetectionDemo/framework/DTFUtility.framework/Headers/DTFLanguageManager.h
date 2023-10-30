//
//  DTFLanguageManager.h
//  DTFUtility
//
//  Created by 汪澌哲 on 2023/8/3.
//  Copyright © 2023 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTFLanguageManager : NSObject

typedef void(^DTFLanguageDownloadCompletionBlock)(NSError *error);

+ (instancetype)sharedInstance;

- (BOOL)checkNeedPreload;
- (BOOL)checkUpdateWithVersion:(NSString *)version;
- (void)startDownloadWithCompletion:(DTFLanguageDownloadCompletionBlock)completion;
- (NSString *)getLocalizedStringForKey:(NSString *)key;
- (NSString *)getMultiFilePath;
- (NSString *)getMultiJsonFile;
- (void)setBundlePath:(NSString *)bundlePath;

@end

NS_ASSUME_NONNULL_END
