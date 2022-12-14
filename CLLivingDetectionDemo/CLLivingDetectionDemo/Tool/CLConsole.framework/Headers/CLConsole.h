//
//  CLConsole.h
//  CLConsole
//
//  Created by wanglijun on 2019/6/13.
//  Copyright © 2019 wanglijun. All rights reserved.
//

#ifndef CLConsole_h
#define CLConsole_h

#import <Foundation/Foundation.h>
#endif /* CLConsole_h */

#define CLConsoleLog(frmt, ...)    LOG_OBJC_MAYBE(frmt, ##__VA_ARGS__)

#define LOG_OBJC_MAYBE(frmt, ...) \
LOG_MAYBE(__PRETTY_FUNCTION__, frmt, ## __VA_ARGS__)

#define LOG_MAYBE(fnct,frmt, ...)                       \
do { if(1 & 1) LOG_MACRO(fnct, frmt, ##__VA_ARGS__); } while(0)


#define LOG_MACRO(fnct, frmt, ...) \
[[CLConsole sharedConsole] function : fnct                          \
line : __LINE__                                           \
format : (frmt), ## __VA_ARGS__]


@interface CLConsole : NSObject

+ (instancetype)sharedConsole;

- (void)startPrintLog;

- (void)stopPrinting;

- (void)function:(const char *)function
            line:(NSUInteger)line
          format:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);

@end
