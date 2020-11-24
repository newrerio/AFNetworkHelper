//
//  AFNetworkHelper.h
//  Action
//
//  Created by caokun on 16/9/3.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

@interface AFNetworkHelper : NSObject

+ (void)postUrlWithoutAuth:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;

+ (void)getUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;
+ (void)postUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;
+ (void)putUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;
+ (void)deleteUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;


+ (void)putImageToUrl:(NSString *)requestUrl bg:(BOOL)bg params:(NSDictionary *)params imgData:(NSData *)imgData succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;
+ (void)postImagesToUrl:(NSString *)requestUrl bg:(BOOL)bg params:(NSDictionary *)params imgDatas:(NSMutableArray *)imgDatas uploadProgressBlock:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail;
@end
