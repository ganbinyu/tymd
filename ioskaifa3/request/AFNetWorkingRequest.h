//
//  AFNetWorkingRequest.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/31.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^block1)(NSDictionary *obj);

@interface AFNetWorkingRequest : NSObject

@property (nonatomic,copy) block1 block;

+(AFNetWorkingRequest*)json;
- (void)downloadJson:(NSString*)jsonURL body:(NSDictionary*)jsonBody block:(block1)block;

@end
