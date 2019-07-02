//
//  AFNetWorkingRequest.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/31.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "AFNetWorkingRequest.h"

static AFNetWorkingRequest *g_AFNetWorkingRequest = nil;

@implementation AFNetWorkingRequest

+(AFNetWorkingRequest*)json {
    @synchronized(self){//@synchronized是同步的意思，目的是防止多个线程同时访问
        if(g_AFNetWorkingRequest == nil){
            g_AFNetWorkingRequest = [[self alloc] init];
        }
    }
    return g_AFNetWorkingRequest;
}


- (void)downloadJson:(NSString*)jsonURL body:(NSDictionary*)jsonBody block:(block1)block {
    self.block = block;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", @"text/plain", nil];//设置内容类型
    [manager POST:jsonURL parameters:jsonBody progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSLog(@"%@",responseObject);
        self.block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

@end
