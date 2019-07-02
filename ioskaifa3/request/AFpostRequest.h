//
//  AFpostRequest.h
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^block1)(NSDictionary* obj);

@interface AFpostRequest : NSObject

@property (nonatomic,copy) block1 block;

+(AFpostRequest*)json;
- (void)downloadJson:(NSString*)jsonURL body:(NSDictionary*)jsonBody finish:(block1)block;
- (void)downloadGetJson:(NSString*)jsonURL finish:(block1)block;

@end
