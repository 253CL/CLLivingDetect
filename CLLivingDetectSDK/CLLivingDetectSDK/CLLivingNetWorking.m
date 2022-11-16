//
//  CLNetWorking.m
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/10/11.
//

#import "CLLivingNetWorking.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#define CLInitURLString @""
#define CLInitTimeInterval 15.0f

@interface CLLivingNetWorking ()

@end

@implementation CLLivingNetWorking
+ (void)cl_requestInitWithAppId:(NSString *)appId{
}

#pragma mark - request
+ (void)requestInitWithURLString:(NSString *)URLString timeInterval:(NSTimeInterval)timeInterval parameters:(NSDictionary *)parameters completion:(void(^)(id data , NSError * _Nullable error))handle {
    @try {
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        request.timeoutInterval = timeInterval > 0 ? timeInterval : CLInitTimeInterval;
        request.HTTPMethod = @"POST";
        
        NSString *POST_BOUNDS = @"yxqipayanzhengtrsfdsdsjifdfsdfv";
        NSMutableString *bodyContent = [NSMutableString string];
        for(NSString *key in parameters.allKeys){
            id value = [parameters objectForKey:key];
            [bodyContent appendFormat:@"--%@\r\n",POST_BOUNDS];
            [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            [bodyContent appendFormat:@"%@\r\n",value];
        }
        [bodyContent appendFormat:@"--%@--\r\n",POST_BOUNDS];
        NSData *bodyData=[bodyContent dataUsingEncoding:NSUTF8StringEncoding];

        [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",POST_BOUNDS] forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:bodyData];
        NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary * dic = [CLLivingNetWorking dataToDictionary:data];
                handle(dic ,error);
            }else{
                handle(nil ,error);
            }
        }];
        [dataTask resume];
        
    } @catch (NSException *exception) {
    }
}



+ (void)requestWithURLString:(NSString *)URLString timeInterval:(NSTimeInterval)timeInterval parameters:(NSDictionary *)parameters completion:(void(^)(NSError * error ,id data))handle {
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.timeoutInterval = timeInterval > 0 ? timeInterval : CLInitTimeInterval;
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [[CLLivingNetWorking dictionaryToJson:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {        
        if (!error) {
            NSDictionary * dic = [CLLivingNetWorking dataToDictionary:data];
            handle(nil,dic);
        }else{
            handle(error,data);
        }
    }];
    [dataTask resume];
}
#pragma mark -private
+ (NSString*)dictionaryToJson:(NSDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dataToDictionary:(NSData *)data{
    if (data == nil) {
        return nil;
    }
    NSError * error;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"解析失败");
        return nil;
    }
    return dic;
}

+ (NSDictionary *)jsonToDictionary:(NSString *)json{
    if (json ==nil) {
        return nil;
    }
    NSData * jsondata = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"解析失败");
        return nil;
    }
    return dic;
}

#pragma mark - setter or getter
@end


@implementation CLLivingTool
+ (NSString *)getRandomString{
    NSString * randoms = [[CLLivingTool secretLoginAndMachineCheckuuidString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (randoms.length != 32) {
        randoms = @"cqwr1v34re3ew34tre3w24rvvbfgsgsf";
    }
    return randoms;
}

+ (NSString *)getBundleId{
    NSString * bundleId = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"CFBundleIdentifier"];
    return bundleId?bundleId:@"";
}

+ (NSString *)getDevice{
    return [NSString stringWithFormat:@"Apple|%@_%@|%@",[[UIDevice currentDevice] systemVersion],[NSProcessInfo processInfo].operatingSystemVersionString,[CLLivingTool getDeviceName]];
}

+ (NSString *)getTimeStamp{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString * timeString   = [NSString stringWithFormat:@"%.0f",interval];
    return timeString;
}

+ (NSNumber *)getCurrentTime{
    return @([[NSDate date] timeIntervalSince1970]);
}

#pragma mark - 加密
+ (NSString *)secretLoginAndMachineCheckuuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+ (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharacters:(NSString *)string {
    if (string == nil ) {
        return nil;
    }
    if (![string isKindOfClass:NSString.class]) {
        return nil;
    }
    NSString *charactersToEscape = @"#[]@!$'()*+,;\"<>%{}|^~`";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString * encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedString;
}


+ (NSString *)secretLoginAndMachineCheckhmacsha1:(NSString *)text key:(NSString *)secret {
//    return [CLTools HmacSha1:secret data:text];
    
    NSString *base64EncodedResult = nil;
    
    @try {
        
        NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
        NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
        unsigned char result[20];
        CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
        char base64Result[32];
        size_t theResultLength = 32;
        secretLoginAndMachineCheckBase64EncodeData(result, 20, base64Result, &theResultLength,YES);
        NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
        base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
        
    } @catch (NSException *exception) {
        
        base64EncodedResult = nil;
        
    } @finally {
        
        return base64EncodedResult;
    }
    
    return base64EncodedResult;
    
}

//base64
const UInt8 secretLoginAndMachineCheckkBase64EncodeTable[64] = {
    /*  0 */ 'A',    /*  1 */ 'B',    /*  2 */ 'C',    /*  3 */ 'D',
    /*  4 */ 'E',    /*  5 */ 'F',    /*  6 */ 'G',    /*  7 */ 'H',
    /*  8 */ 'I',    /*  9 */ 'J',    /* 10 */ 'K',    /* 11 */ 'L',
    /* 12 */ 'M',    /* 13 */ 'N',    /* 14 */ 'O',    /* 15 */ 'P',
    /* 16 */ 'Q',    /* 17 */ 'R',    /* 18 */ 'S',    /* 19 */ 'T',
    /* 20 */ 'U',    /* 21 */ 'V',    /* 22 */ 'W',    /* 23 */ 'X',
    /* 24 */ 'Y',    /* 25 */ 'Z',    /* 26 */ 'a',    /* 27 */ 'b',
    /* 28 */ 'c',    /* 29 */ 'd',    /* 30 */ 'e',    /* 31 */ 'f',
    /* 32 */ 'g',    /* 33 */ 'h',    /* 34 */ 'i',    /* 35 */ 'j',
    /* 36 */ 'k',    /* 37 */ 'l',    /* 38 */ 'm',    /* 39 */ 'n',
    /* 40 */ 'o',    /* 41 */ 'p',    /* 42 */ 'q',    /* 43 */ 'r',
    /* 44 */ 's',    /* 45 */ 't',    /* 46 */ 'u',    /* 47 */ 'v',
    /* 48 */ 'w',    /* 49 */ 'x',    /* 50 */ 'y',    /* 51 */ 'z',
    /* 52 */ '0',    /* 53 */ '1',    /* 54 */ '2',    /* 55 */ '3',
    /* 56 */ '4',    /* 57 */ '5',    /* 58 */ '6',    /* 59 */ '7',
    /* 60 */ '8',    /* 61 */ '9',    /* 62 */ '+',    /* 63 */ '/'
};

/*
 -1 = Base64 end of data marker.
 -2 = White space (tabs, cr, lf, space)
 -3 = Noise (all non whitespace, non-base64 characters)
 -4 = Dangerous noise
 -5 = Illegal noise (null byte)
 */

const SInt8 secretLoginAndMachineCheckkBase64DecodeTable[128] = {
    /* 0x00 */ -5,     /* 0x01 */ -3,     /* 0x02 */ -3,     /* 0x03 */ -3,
    /* 0x04 */ -3,     /* 0x05 */ -3,     /* 0x06 */ -3,     /* 0x07 */ -3,
    /* 0x08 */ -3,     /* 0x09 */ -2,     /* 0x0a */ -2,     /* 0x0b */ -2,
    /* 0x0c */ -2,     /* 0x0d */ -2,     /* 0x0e */ -3,     /* 0x0f */ -3,
    /* 0x10 */ -3,     /* 0x11 */ -3,     /* 0x12 */ -3,     /* 0x13 */ -3,
    /* 0x14 */ -3,     /* 0x15 */ -3,     /* 0x16 */ -3,     /* 0x17 */ -3,
    /* 0x18 */ -3,     /* 0x19 */ -3,     /* 0x1a */ -3,     /* 0x1b */ -3,
    /* 0x1c */ -3,     /* 0x1d */ -3,     /* 0x1e */ -3,     /* 0x1f */ -3,
    /* ' ' */ -2,    /* '!' */ -3,    /* '"' */ -3,    /* '#' */ -3,
    /* '$' */ -3,    /* '%' */ -3,    /* '&' */ -3,    /* ''' */ -3,
    /* '(' */ -3,    /* ')' */ -3,    /* '*' */ -3,    /* '+' */ 62,
    /* ',' */ -3,    /* '-' */ -3,    /* '.' */ -3,    /* '/' */ 63,
    /* '0' */ 52,    /* '1' */ 53,    /* '2' */ 54,    /* '3' */ 55,
    /* '4' */ 56,    /* '5' */ 57,    /* '6' */ 58,    /* '7' */ 59,
    /* '8' */ 60,    /* '9' */ 61,    /* ':' */ -3,    /* ';' */ -3,
    /* '<' */ -3,    /* '=' */ -1,    /* '>' */ -3,    /* '?' */ -3,
    /* '@' */ -3,    /* 'A' */ 0,    /* 'B' */  1,    /* 'C' */  2,
    /* 'D' */  3,    /* 'E' */  4,    /* 'F' */  5,    /* 'G' */  6,
    /* 'H' */  7,    /* 'I' */  8,    /* 'J' */  9,    /* 'K' */ 10,
    /* 'L' */ 11,    /* 'M' */ 12,    /* 'N' */ 13,    /* 'O' */ 14,
    /* 'P' */ 15,    /* 'Q' */ 16,    /* 'R' */ 17,    /* 'S' */ 18,
    /* 'T' */ 19,    /* 'U' */ 20,    /* 'V' */ 21,    /* 'W' */ 22,
    /* 'X' */ 23,    /* 'Y' */ 24,    /* 'Z' */ 25,    /* '[' */ -3,
    /* '\' */ -3,    /* ']' */ -3,    /* '^' */ -3,    /* '_' */ -3,
    /* '`' */ -3,    /* 'a' */ 26,    /* 'b' */ 27,    /* 'c' */ 28,
    /* 'd' */ 29,    /* 'e' */ 30,    /* 'f' */ 31,    /* 'g' */ 32,
    /* 'h' */ 33,    /* 'i' */ 34,    /* 'j' */ 35,    /* 'k' */ 36,
    /* 'l' */ 37,    /* 'm' */ 38,    /* 'n' */ 39,    /* 'o' */ 40,
    /* 'p' */ 41,    /* 'q' */ 42,    /* 'r' */ 43,    /* 's' */ 44,
    /* 't' */ 45,    /* 'u' */ 46,    /* 'v' */ 47,    /* 'w' */ 48,
    /* 'x' */ 49,    /* 'y' */ 50,    /* 'z' */ 51,    /* '{' */ -3,
    /* '|' */ -3,    /* '}' */ -3,    /* '~' */ -3,    /* 0x7f */ -3
};

const UInt8 secretLoginAndMachineCheckkBits_00000011 = 0x03;
const UInt8 secretLoginAndMachineCheckkBits_00001111 = 0x0F;
const UInt8 secretLoginAndMachineCheckkBits_00110000 = 0x30;
const UInt8 secretLoginAndMachineCheckkBits_00111100 = 0x3C;
const UInt8 secretLoginAndMachineCheckkBits_00111111 = 0x3F;
const UInt8 secretLoginAndMachineCheckkBits_11000000 = 0xC0;
const UInt8 secretLoginAndMachineCheckkBits_11110000 = 0xF0;
const UInt8 secretLoginAndMachineCheckkBits_11111100 = 0xFC;

size_t secretLoginAndMachineCheckEstimateBas64EncodedDataSize(size_t inDataSize)
{
    size_t theEncodedDataSize = (int)ceil(inDataSize / 3.0) * 4;
    theEncodedDataSize = theEncodedDataSize / 72 * 74 + theEncodedDataSize % 72;
    return(theEncodedDataSize);
}

size_t secretLoginAndMachineCheckEstimateBas64DecodedDataSize(size_t inDataSize)
{
    size_t theDecodedDataSize = (int)ceil(inDataSize / 4.0) * 3;
    //theDecodedDataSize = theDecodedDataSize / 72 * 74 + theDecodedDataSize % 72;
    return(theDecodedDataSize);
}

bool secretLoginAndMachineCheckBase64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped)
{
    size_t theEncodedDataSize = secretLoginAndMachineCheckEstimateBas64EncodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theEncodedDataSize)
        return(false);
    *ioOutputDataSize = theEncodedDataSize;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt32 theInIndex = 0, theOutIndex = 0;
    for (; theInIndex < (inInputDataSize / 3) * 3; theInIndex += 3)
    {
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex] & secretLoginAndMachineCheckkBits_11111100) >> 2];
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex] & secretLoginAndMachineCheckkBits_00000011) << 4 | (theInPtr[theInIndex + 1] & secretLoginAndMachineCheckkBits_11110000) >> 4];
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex + 1] & secretLoginAndMachineCheckkBits_00001111) << 2 | (theInPtr[theInIndex + 2] & secretLoginAndMachineCheckkBits_11000000) >> 6];
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex + 2] & secretLoginAndMachineCheckkBits_00111111) >> 0];
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    const size_t theRemainingBytes = inInputDataSize - theInIndex;
    if (theRemainingBytes == 1)
    {
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex] & secretLoginAndMachineCheckkBits_11111100) >> 2];
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex] & secretLoginAndMachineCheckkBits_00000011) << 4 | (0 & secretLoginAndMachineCheckkBits_11110000) >> 4];
        outOutputData[theOutIndex++] = '=';
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    else if (theRemainingBytes == 2)
    {
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex] & secretLoginAndMachineCheckkBits_11111100) >> 2];
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex] & secretLoginAndMachineCheckkBits_00000011) << 4 | (theInPtr[theInIndex + 1] & secretLoginAndMachineCheckkBits_11110000) >> 4];
        outOutputData[theOutIndex++] = secretLoginAndMachineCheckkBase64EncodeTable[(theInPtr[theInIndex + 1] & secretLoginAndMachineCheckkBits_00001111) << 2 | (0 & secretLoginAndMachineCheckkBits_11000000) >> 6];
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    return(true);
}

bool secretLoginAndMachineCheckBase64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize)
{
    memset(ioOutputData, '.', *ioOutputDataSize);
    
    size_t theDecodedDataSize = secretLoginAndMachineCheckEstimateBas64DecodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theDecodedDataSize)
        return(false);
    *ioOutputDataSize = 0;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt8 *theOutPtr = (UInt8 *)ioOutputData;
    size_t theInIndex = 0, theOutIndex = 0;
    UInt8 theOutputOctet = '\0';
    size_t theSequence = 0;
    for (; theInIndex < inInputDataSize; )
    {
        SInt8 theSextet = 0;
        
        SInt8 theCurrentInputOctet = theInPtr[theInIndex];
        theSextet = secretLoginAndMachineCheckkBase64DecodeTable[theCurrentInputOctet];
        if (theSextet == -1)
            break;
        while (theSextet == -2)
        {
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = secretLoginAndMachineCheckkBase64DecodeTable[theCurrentInputOctet];
        }
        while (theSextet == -3)
        {
            theCurrentInputOctet = theInPtr[++theInIndex];
            theSextet = secretLoginAndMachineCheckkBase64DecodeTable[theCurrentInputOctet];
        }
        if (theSequence == 0)
        {
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 2 & secretLoginAndMachineCheckkBits_11111100;
        }
        else if (theSequence == 1)
        {
            theOutputOctet |= (theSextet >- 0 ? theSextet : 0) >> 4 & secretLoginAndMachineCheckkBits_00000011;
            theOutPtr[theOutIndex++] = theOutputOctet;
        }
        else if (theSequence == 2)
        {
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 4 & secretLoginAndMachineCheckkBits_11110000;
        }
        else if (theSequence == 3)
        {
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 2 & secretLoginAndMachineCheckkBits_00001111;
            theOutPtr[theOutIndex++] = theOutputOctet;
        }
        else if (theSequence == 4)
        {
            theOutputOctet = (theSextet >= 0 ? theSextet : 0) << 6 & secretLoginAndMachineCheckkBits_11000000;
        }
        else if (theSequence == 5)
        {
            theOutputOctet |= (theSextet >= 0 ? theSextet : 0) >> 0 & secretLoginAndMachineCheckkBits_00111111;
            theOutPtr[theOutIndex++] = theOutputOctet;
        }
        theSequence = (theSequence + 1) % 6;
        if (theSequence != 2 && theSequence != 4)
            theInIndex++;
    }
    *ioOutputDataSize = theOutIndex;
    return(true);
}

//HmacSHA1加密；
//+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data{
//    if (key == nil || data == nil) {
//        return nil;
//    }
//    if (![key isKindOfClass:NSString.class] || ![data isKindOfClass:NSString.class]) {
//        return nil;
//    }
//    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
//    //Sha256:
//    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
//    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    //sha1
//    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
//    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
//    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
//    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
//    return hash;
//}


+ (nullable NSString *)md5:(nullable NSString *)str {
    if (!str) return nil;
    
    const char *cStr = str.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

+ (NSString *)getDeviceModel{
    @try {
        struct utsname systemInfomation;
        uname(&systemInfomation);
        NSString *device = @"";
        char *machine = systemInfomation.machine;
        if (machine && *machine) {
            device = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        }
        return device;
    } @catch (NSException *exception) {
        return @"UNKNOW";
    }
}


+ (NSString *)getDeviceName {
    @try {
        struct utsname systemInfomation;
        uname(&systemInfomation);

        NSString *device = [NSString stringWithCString:systemInfomation.machine encoding:NSUTF8StringEncoding];

        if([device isEqualToString:@"iPhone1,1"])    return@"iPhone1G";

        if([device isEqualToString:@"iPhone1,2"])    return@"iPhone3G";

        if([device isEqualToString:@"iPhone2,1"])    return@"iPhone3GS";

        if([device isEqualToString:@"iPhone3,1"])    return@"iPhone4";

        if([device isEqualToString:@"iPhone3,2"])    return@"iPhone4";

        if([device isEqualToString:@"iPhone3,3"])    return@"iPhone4";

        if([device isEqualToString:@"iPhone4,1"])    return@"iPhone4S";

        if([device isEqualToString:@"iPhone5,1"])    return@"iPhone5";

        if([device isEqualToString:@"iPhone5,2"])    return@"iPhone5";

        if([device isEqualToString:@"iPhone5,3"])    return@"iPhone5C";

        if([device isEqualToString:@"iPhone5,4"])    return@"iPhone5C";

        if([device isEqualToString:@"iPhone6,1"])    return@"iPhone5S";

        if([device isEqualToString:@"iPhone6,2"])    return@"iPhone5S";

        if([device isEqualToString:@"iPhone7,1"])    return@"iPhone6Plus";

        if([device isEqualToString:@"iPhone7,2"])    return@"iPhone6";

        if([device isEqualToString:@"iPhone8,1"])    return@"iPhone6s";

        if([device isEqualToString:@"iPhone8,2"])    return@"iPhone6sPlus";

        if([device isEqualToString:@"iPhone8,4"])    return@"iPhoneSE";

        if([device isEqualToString:@"iPhone9,1"])    return@"iPhone7";

        if([device isEqualToString:@"iPhone9,3"])    return@"iPhone7";

        if([device isEqualToString:@"iPhone9,2"])    return@"iPhone7Plus";

        if([device isEqualToString:@"iPhone9,4"])    return@"iPhone7Plus";

        if([device isEqualToString:@"iPhone10,1"])  return@"iPhone8";

        if ([device isEqualToString:@"iPhone10,2"])  return @"iPhone8Plus";

        if([device isEqualToString:@"iPhone10,3"])  return@"iPhoneX";

        if([device isEqualToString:@"iPhone10,4"])  return@"iPhone8";

        if ([device isEqualToString:@"iPhone10,5"])  return @"iPhone8Plus";

        if([device isEqualToString:@"iPhone10,6"])  return@"iPhoneX";

        if([device isEqualToString:@"iPhone11,8"])  return@"iPhoneXR";

        if([device isEqualToString:@"iPhone11,2"])  return@"iPhoneXS";

        if([device isEqualToString:@"iPhone11,6"])  return@"iPhoneXS Max";
        if ([device isEqualToString:@"iPhone11,4"]) { return @"iPhoneXS Max"; }

        if([device isEqualToString:@"iPhone12,1"])  return @"iPhone11";
        if([device isEqualToString:@"iPhone12,3"])  return @"iPhone11Pro";
        if([device isEqualToString:@"iPhone12,5"])  return @"iPhone11ProMax";
        
        if ([device isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
        if ([device isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
        if ([device isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
        if ([device isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";

        if ([device isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
        if ([device isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
        if ([device isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
        if ([device isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
        if ([device isEqualToString:@"iPhone14,6"]) return @"iPhone SE (3rd generation)";
        if ([device isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
        if ([device isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
        if ([device isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
        if ([device isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
        

        // iPad
        if ([device isEqualToString:@"iPad1,1"]) {
            return @"iPad Touch 1G";
        }

        if ([device isEqualToString:@"iPad2,1"]) {
            return @"iPad 2 (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad2,2"]) {
            return @"iPad 2 (GSM)";
        }

        if ([device isEqualToString:@"iPad2,3"]) {
            return @"iPad 2 (CDMA)";
        }

        if ([device isEqualToString:@"iPad2,4"]) {
            return @"iPad 2 (Wi-Fi, revised)";
        }

        if ([device isEqualToString:@"iPad2,5"]) {
            return @"iPad mini (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad2,6"]) {
            return @"iPad mini (A1454)";
        }

        if ([device isEqualToString:@"iPad2,7"]) {
            return @"iPad mini (A1455)";
        }

        if ([device isEqualToString:@"iPad3,1"]) {
            return @"iPad (3rd gen, Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad3,2"]) {
            return @"iPad (3rd gen, Wi-Fi+LTE Verizon)";
        }

        if ([device isEqualToString:@"iPad3,3"]) {
            return @"iPad (3rd gen, Wi-Fi+LTE AT&T)";
        }

        if ([device isEqualToString:@"iPad3,4"]) {
            return @"iPad (4th gen, Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad3,5"]) {
            return @"iPad (4th gen, A1459)";
        }

        if ([device isEqualToString:@"iPad3,6"]) {
            return @"iPad (4th gen, A1460)";
        }

        if ([device isEqualToString:@"iPad4,1"]) {
            return @"iPad Air (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad4,2"]) {
            return @"iPad Air (Wi-Fi+LTE)";
        }

        if ([device isEqualToString:@"iPad4,3"]) {
            return @"iPad Air (Rev)";
        }

        if ([device isEqualToString:@"iPad4,4"]) {
            return @"iPad Mini (2nd gen, Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad4,5"]) {
            return @"iPad mini 2 (Wi-Fi+LTE)";
        }

        if ([device isEqualToString:@"iPad4,6"]) {
            return @"iPad mini 2 (Rev)";
        }

        if ([device isEqualToString:@"iPad4,7"]) {
            return @"iPad mini 3 (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad4,8"]) {
            return @"iPad mini 3 (A1600)";
        }

        if ([device isEqualToString:@"iPad4,9"]) {
            return @"iPad mini 3 (A1601)";
        }

        if ([device isEqualToString:@"iPad5,1"]) {
            return @"iPad mini 4 (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad5,2"]) {
            return @"iPad mini 4 (Wi-Fi+LTE)";
        }

        if ([device isEqualToString:@"iPad5,3"]) {
            return @"iPad Air 2 (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad5,4"]) {
            return @"iPad Air 2 (Wi-Fi+LTE)";
        }

        if ([device isEqualToString:@"iPad6,3"]) {
            return @"iPad Pro (9.7 inch) (Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad6,4"]) {
            return @"iPad Pro (9.7 inch) (Wi-Fi+LTE)";
        }

        if ([device isEqualToString:@"iPad6,7"]) {
            return @"iPad Pro (12.9 inch, Wi-Fi)";
        }

        if ([device isEqualToString:@"iPad6,8"]) {
            return @"iPad Pro (12.9 inch, Wi-Fi+LTE)";
        }

        if ([device isEqualToString:@"iPad6,11"]) {
            return @"iPad 9.7-Inch 5th Gen (Wi-Fi Only)";
        }

        if ([device isEqualToString:@"iPad6,12"]) {
            return @"iPad 9.7-Inch 5th Gen (Wi-Fi/Cellular)";
        }

        if ([device isEqualToString:@"iPad7,3"]) {
            return @"iPad Pro (10.5 inch, A1701)";
        }

        if ([device isEqualToString:@"iPad7,4"]) {
            return @"iPad Pro (10.5 inch, A1709)";
        }

        if ([device isEqualToString:@"iPad7,5"]) {
            return @"iPad (6th gen, A1893)";
        }
        if ([device isEqualToString:@"iPad7,6"]) return @"iPad (6th gen, A1954)";
        if ([device isEqualToString:@"iPad8,1"] ||
            [device isEqualToString:@"iPad8,2"] ||
            [device isEqualToString:@"iPad8,3"] ||
            [device isEqualToString:@"iPad8,4"]) return @"iPad Pro 11 inch";
        if ([device isEqualToString:@"iPad8,9"] ||
            [device isEqualToString:@"iPad8,10"]) return @"iPad Pro 11 inch 2";
        if ([device isEqualToString:@"iPad8,5"] ||
            [device isEqualToString:@"iPad8,6"] ||
            [device isEqualToString:@"iPad8,7"] ||
            [device isEqualToString:@"iPad8,8"]) return @"iPad Pro 12.9 inch 3";
        if ([device isEqualToString:@"iPad8,11"] ||
            [device isEqualToString:@"iPad8,12"]) return @"iPad Pro 12.9 inch 4";
        if ([device isEqualToString:@"iPad11,1"]
            || [device isEqualToString:@"iPad11,2"])  return @"iPad mini (5th generation)";
        if ([device isEqualToString:@"iPad11,3"] ||
            [device isEqualToString:@"iPad11,4"]) return @"iPad Air 3";
        if ([device isEqualToString:@"iPad11,6"]
            || [device isEqualToString:@"iPad11,7"])   return @"iPad (8th generation)";
        if ([device isEqualToString:@"iPad12,1"]
            || [device isEqualToString:@"iPad12,2"])   return @"iPad (9th generation)";
        if ([device isEqualToString:@"iPad13,1"] ||
            [device isEqualToString:@"iPad13,2"]) return @"iPad Air 4";
        if ([device isEqualToString:@"iPad13,4"]
            || [device isEqualToString:@"iPad13,5"]
            || [device isEqualToString:@"iPad13,6"]
            || [device isEqualToString:@"iPad13,7"])  return @"iPad Pro (11-inch) (3rd generation)";
        if ([device isEqualToString:@"iPad13,8"]
            || [device isEqualToString:@"iPad13,9"]
            || [device isEqualToString:@"iPad13,10"]
            || [device isEqualToString:@"iPad13,11"]) return @"iPad Pro (12.9-inch) (5th generation)";
        if ([device isEqualToString:@"iPad14,1"]
            || [device isEqualToString:@"iPad14,2"])  return @"iPad mini (6th generation)";

        // iPod
        if ([device isEqualToString:@"iPod1,1"]) return @"iPod touch";
        if ([device isEqualToString:@"iPod2,1"]) return @"iPod touch (2nd gen)";
        if ([device isEqualToString:@"iPod3,1"]) return @"iPod touch (3rd gen)";
        if ([device isEqualToString:@"iPod4,1"]) return @"iPod touch (4th gen)";
        if ([device isEqualToString:@"iPod5,1"]) return @"iPod touch (5th gen)";
        if ([device isEqualToString:@"iPod7,1"]) return @"iPod touch (6th gen)";
        if ([device isEqualToString:@"iPod9,1"]) return @"iPod touch (7th generation)";
           

        // Simulator
        if ([device isEqualToString:@"i386"]) return @"iOS i386 Simulator";

        if ([device isEqualToString:@"x86_64"]) return @"iOS x86_64 Simulator";

        return device;
    } @catch (NSException *exception) {
        return @"UNKNOW";
    }
}


+(NSNumber * _Nullable)clCodeWithError:(NSError * )error{
    NSArray * codeKeys = @[@"resultCode",@"result",@"retCode",@"code"];
    if ([error.userInfo isKindOfClass:NSDictionary.class] && error.userInfo.count > 0) {
        NSArray * allKeys = error.userInfo.allKeys;
        for (NSString * codeKey in codeKeys) {
            if ([allKeys containsObject:codeKey]) {
                NSString * value = [error.userInfo objectForKey:codeKey];
                NSInteger code = [value integerValue];
                return [NSNumber numberWithInteger:code];
            }
        }
        return [NSNumber numberWithInteger:error.code];
    }
    return nil;
}
+(NSString * _Nullable)clDescripetionWithError:(NSError * )error{
    NSArray * descKeys = @[@"desc",@"resultMsg",@"msg",@"retMsg",@"NSLocalizedDescription"];
    if ([error.userInfo isKindOfClass:NSDictionary.class] && error.userInfo.count > 0) {
        NSArray * allKeys = error.userInfo.allKeys;
        for (NSString * descKey in descKeys) {
            if ([allKeys containsObject:descKey]) {
                NSString * value = [error.userInfo objectForKey:descKey];
                return value;
            }
        }
        return error.userInfo.description;
    }
    return nil;
}


@end

