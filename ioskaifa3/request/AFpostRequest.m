//
//  AFpostRequest.m
//  ioskaifa3
//
//  Created by ganbinyu on 2018/8/24.
//  Copyright © 2018年 Mr Gan. All rights reserved.
//

#import "AFpostRequest.h"
#import "AFNetworking.h"

static AFpostRequest *g_AFpostRequest = nil;

@implementation AFpostRequest

+(AFpostRequest*)json {
    @synchronized(self){//@synchronized是同步的意思，目的是防止多个线程同时访问
        if(g_AFpostRequest == nil){
            g_AFpostRequest = [[self alloc] init];
        }
    }
    return g_AFpostRequest;
}

- (void)downloadJson:(NSString*)jsonURL body:(NSDictionary*)jsonBody finish:(block1)block{
    self.block = block;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", @"text/plain", nil];//设置内容类型
    [manager POST:jsonURL parameters:jsonBody progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        self.block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)downloadGetJson:(NSString*)jsonURL finish:(block1)block {
    self.block = block;
    NSURL *url = [NSURL URLWithString:[jsonURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            self.block(dic);
        }
    }];
    [task resume];
    
}

@end
