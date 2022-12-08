//
//  FaceViewProviderProtocol.h
//  DTFUIModule
//
//  Created by mengbingchuan on 2022/8/29.
//  Copyright © 2022  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTFFaceViewProtocol.h"

@protocol DTFViewProviderProtocol <NSObject>

- (id<DTFFaceViewProtocol>)viewForFace;

@end
