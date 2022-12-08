//
//  DTFRpcBaseOperation.h
//  APMobileRPC
//
//  Created by richard on 09/02/2018.
//  Copyright © 2018 Alipay. All rights reserved.
//


#import "DTFURLRequestOperation.h"

@interface DTFRpcBaseOperation : DTFURLRequestOperation

@property(nonatomic, strong) NSDictionary *responseJSON;
@property(nonatomic, strong) NSDictionary *resultJSON;
@property(nonatomic,strong)NSDictionary *addHeaders;
@end
