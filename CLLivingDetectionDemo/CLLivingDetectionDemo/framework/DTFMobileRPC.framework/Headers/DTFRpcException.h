//
//  DTFRpcException.h
//  APMobileRPC
//
//  Created by richard on 11/02/2018.
//  Copyright © 2018 Alipay. All rights reserved.
//

#import "DTFRpcErrorCode.h"

/** The name of the RPC exception. */
extern NSString * const kDTFRpcException;

/**
 * NSException is used to implement exception handling and contains information about an RPC exception.
 */
@interface DTFRpcException : NSException

@property(nonatomic, assign) DTFRpcErrorCode code;

+ (void)raise:(DTFRpcErrorCode)code message:(NSString *)message;

+ (void)raise:(DTFRpcErrorCode)code message:(NSString *)message userInfo:(NSDictionary*)userInfo;

@end
