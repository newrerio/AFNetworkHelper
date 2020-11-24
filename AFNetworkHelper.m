//
//  AFNetworkHelper.m
//  Action
//
//  Created by caokun on 16/9/3.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "AFNetworkHelper.h"

@implementation AFNetworkHelper


+ (void)getUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self handleUrl:requestUrl method:@"GET" bg:bg param:param succeed:succeed fail:fail];
}

+ (void)postUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self handleUrl:requestUrl method:@"POST" bg:bg param:param succeed:succeed fail:fail];
}

+ (void)putUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self handleUrl:requestUrl method:@"PUT" bg:bg param:param succeed:succeed fail:fail];
}

+ (void)deleteUrl:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self handleUrl:requestUrl method:@"DELETE" bg:bg param:param succeed:succeed fail:fail];
}

+ (void)handleUrl:(NSString *)requestUrl method:(NSString *)method bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self requestWithAuth:requestUrl bg:bg param:param method:method succeed:^(id responseObject) {
        if (isNull(responseObject) == YES) {
            fail();
            if (bg == NO) {
                showAndHideWrongJuHua(@"返回数据格式错误",[rootDelegate topViewController].view);
            }
            return;
        }
        succeed(responseObject);
    } fail:^{
        fail();
    }];

}

//上传或者修改1张图片
+ (void)putImageToUrl:(NSString *)requestUrl bg:(BOOL)bg params:(NSDictionary *)params imgData:(NSData *)imgData succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self uploadImgToUrlWithAuth:requestUrl bg:bg parameters:params imgData:imgData method:@"PUT" succeed:^(id responseObject) {
        if (isNull(responseObject) == YES) {
            fail();
            if (bg == NO) {
                showAndHideWrongJuHua(@"返回数据格式错误",[rootDelegate topViewController].view);
            }
            return;
        }
        succeed(responseObject);
    } fail:^{
        fail();
    }];
}

//上传多张图片
+ (void)postImagesToUrl:(NSString *)requestUrl bg:(BOOL)bg params:(NSDictionary *)params imgDatas:(NSMutableArray *)imgDatas uploadProgressBlock:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self uploadImgsToUrlWithAuth:requestUrl bg:bg parameters:params arrImgData:imgDatas method:@"POST" uploadProgressBlock:uploadProgressBlock succeed:^(id responseObject) {
        if (isNull(responseObject) == YES) {
            fail();
            if (bg == NO) {
                showAndHideWrongJuHua(@"返回数据格式错误",[rootDelegate topViewController].view);
            }
            return;
        }
        succeed(responseObject);
    } fail:^{
        fail();
    }];
}


//-------------middle----------------
//统一处理服务器返回的错误码、auth未认证

+ (void)requestWithAuth:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param method:(NSString *)method succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self requestUrl:requestUrl bg:bg needAuthHeader:YES param:param method:method succeed:^(NSURLResponse *response, id responseObject) {
        if (isNull([responseObject objectForKey:@"ok"]) == false && [[responseObject objectForKey:@"ok"] boolValue] == false) {
            if (bg == NO) {
                showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"msg"],nil), [rootDelegate topViewController].view);
            }
            fail();
        }else{
            succeed(responseObject);
        }
    } fail:^{
        fail();
    }];
}

+ (void)postUrlWithoutAuth:(NSString *)requestUrl bg:(BOOL)bg param:(NSDictionary *)param succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self requestUrl:requestUrl bg:bg needAuthHeader:NO param:param method:@"POST" succeed:^(NSURLResponse *response, id responseObject) {
        if (isNull([responseObject objectForKey:@"ok"]) == false && [[responseObject objectForKey:@"ok"] boolValue] == false) {
            if (bg == NO) {
                showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"msg"],nil), [rootDelegate topViewController].view);
            }
            fail();
        }else{
            succeed(responseObject);
        }
    } fail:^{
        fail();
    }];
}


+ (void)uploadImgToUrlWithAuth:(NSString *)requestUrl bg:(BOOL)bg parameters:(NSDictionary *)params imgData:(NSData *)imgData method:(NSString *)method succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self uploadImgToUrl:requestUrl bg:bg parameters:params needAuthHeader:YES imgData:imgData method:method succeed:^(NSURLResponse *response, id responseObject) {
        if (isNull([responseObject objectForKey:@"ok"]) == false && [[responseObject objectForKey:@"ok"] boolValue] == false) {
            if (bg == NO) {
                showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"msg"],nil), [rootDelegate topViewController].view);
            }
            fail();
        }else{
            succeed(responseObject);
        }
    } fail:^{
        fail();
    }];
}

+ (void)uploadImgsToUrlWithAuth:(NSString *)requestUrl bg:(BOOL)bg parameters:(NSDictionary *)params arrImgData:(NSMutableArray *)arrImgData method:(NSString *)method uploadProgressBlock:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock succeed:(void (^)(id responseObject))succeed  fail:(void (^)(void))fail{
    [self uploadImgsToUrl:requestUrl bg:bg needAuthHeader:YES parameters:params arrImgData:arrImgData method:method uploadProgressBlock:uploadProgressBlock succeed:^(NSURLResponse *response, id responseObject) {
        if (isNull([responseObject objectForKey:@"ok"]) == false && [[responseObject objectForKey:@"ok"] boolValue] == false) {
            if (bg == NO) {
                showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"msg"],nil), [rootDelegate topViewController].view);
            }
            fail();
        }else{
            succeed(responseObject);
        }
    } fail:^{
        fail();
    }];
}

//===============low=================
//统一处理error、auth本地过期、空返回

+ (void)requestUrl:(NSString *)requestUrl bg:(BOOL)bg needAuthHeader:(BOOL)needAuthHeader param:(NSDictionary *)param method:(NSString *)method succeed:(void (^)(NSURLResponse *response, id responseObject))succeed fail:(void (^)(void))fail{
    if (needAuthHeader == YES) {
        //uct to nsdate
        NSString *expire = getUserTokenExpire;
        if (isNullString(expire) == NO) {
            NSDate *expireDate = [expire dateFromRFC3339String];//utc格式为RFC3339：2016-09-21T20:55:46+08:00
            if ([[NSDate date] isLaterThanDate:expireDate]) {
                //token 不存在或者已经过期
                //进入登录
                [rootDelegate logoutWithMsg:@"token expired"];
                fail();
                return;
            }
        }
    }
    
    requestUrl = [NSString stringWithFormat:@"%@?v=%@",requestUrl,kApiVersion];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:[requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:param error:nil];
    request.timeoutInterval = 15;
    if (needAuthHeader) {
        [request setValue:getAuthString forHTTPHeaderField:kAuth];
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //ssl
    NSData *certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kHttpsCerName ofType:@"cer"]];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:certData, nil]];
    if (isDebugMode) {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (isNull(error) == NO) {
            if (bg == NO) {
                //jwt_login返回的错误信息字段为message
                if (isNull([responseObject objectForKey:@"message"]) == false && [[responseObject objectForKey:@"message"] boolValue] == false) {
                    if ([[responseObject objectForKey:@"message"] isEqualToString:@"not authorized"]) {
                        [rootDelegate logoutWithMsg:@"not authorized"];
                    }else{
                        showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"message"],nil), [rootDelegate topViewController].view);
                    }
                }else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    if ([httpResponse statusCode] == 401) {
                        showAndHideWrongJuHua(@"认证失败",[rootDelegate topViewController].view);
                    }else{
                        showAndHideWrongJuHua(error.localizedDescription,[rootDelegate topViewController].view);
                    }
                }
            }
            fail();
            return;
        }
        
        if (isNull(responseObject)) {
            if (bg == NO) {
                NSLog(@"responseObject:%@",responseObject);
                showAndHideWrongJuHua(@"返回空数据", [rootDelegate topViewController].view);
            }
            fail();
            return;
        }
        
        succeed(response,responseObject);
    }] resume];
}

+ (void)uploadImgToUrl:(NSString *)requestUrl bg:(BOOL)bg parameters:(NSDictionary *)params needAuthHeader:(BOOL)needAuthHeader imgData:(NSData *)imgData method:(NSString *)method succeed:(void (^)(NSURLResponse *response, id responseObject))succeed fail:(void (^)(void))fail{
    [self uploadImgFunc:requestUrl bg:bg needAuthHeader:needAuthHeader parameters:params imgData:imgData arrImgData:nil method:method uploadProgressBlock:nil succeed:succeed fail:fail];
}

+ (void)uploadImgsToUrl:(NSString *)requestUrl bg:(BOOL)bg needAuthHeader:(BOOL)needAuthHeader parameters:(NSDictionary *)params arrImgData:(NSMutableArray *)arrImgData method:(NSString *)method uploadProgressBlock:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock succeed:(void (^)(NSURLResponse *response, id responseObject))succeed fail:(void (^)(void))fail{
    [self uploadImgFunc:requestUrl bg:bg needAuthHeader:needAuthHeader parameters:params imgData:nil arrImgData:arrImgData method:method uploadProgressBlock:uploadProgressBlock succeed:succeed fail:fail];
}

+ (void)uploadImgFunc:(NSString *)requestUrl bg:(BOOL)bg needAuthHeader:(BOOL)needAuthHeader parameters:(NSDictionary *)params imgData:(NSData *)imgData arrImgData:(NSMutableArray *)arrImgData method:(NSString *)method uploadProgressBlock:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock succeed:(void (^)(NSURLResponse *response, id responseObject))succeed fail:(void (^)(void))fail{
    if (needAuthHeader == YES) {
        //uct to nsdate
        NSString *expire = getUserTokenExpire;
        if (isNullString(expire) == NO) {
            NSDate *expireDate = [expire dateFromRFC3339String];
            if ([[NSDate date] isLaterThanDate:expireDate]) {
                //token 不存在或者已经过期
                //进入登录
                [rootDelegate logoutWithMsg:@"token expired"];
                fail();
                return;
            }
        }
    }
    
    BOOL isOnePic;
    if (isNull(arrImgData) == NO) {
        isOnePic = NO;
    }else{
        isOnePic = YES;
    }
    
    requestUrl = [NSString stringWithFormat:@"%@?v=%@",requestUrl,kApiVersion];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:[requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        if (isOnePic) {
            [formData appendPartWithFileData:imgData name:@"files" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        }else{
            for (NSData *data in arrImgData) {
                [formData appendPartWithFileData:data name:@"files" fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpeg"];
                i++;
            }
        }
    } error:nil];
    if (needAuthHeader) {
        [request setValue:getAuthString forHTTPHeaderField:kAuth];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //ssl
    NSData *certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kHttpsCerName ofType:@"cer"]];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:certData, nil]];
    if (isDebugMode) {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    [[manager uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (isNull(error) == NO) {
            if (bg == NO) {
                //jwt_login返回的错误信息字段为message
                if (isNull([responseObject objectForKey:@"message"]) == false && [[responseObject objectForKey:@"message"] boolValue] == false) {
                    if ([[responseObject objectForKey:@"message"] isEqualToString:@"not authorized"]) {
                        [rootDelegate logoutWithMsg:@"not authorized"];
                    }else{
                        showAndHideWrongJuHua(NSLocalizedString([responseObject objectForKey:@"message"],nil), [rootDelegate topViewController].view);
                    }
                }else{
                    showAndHideWrongJuHua(error.localizedDescription,[rootDelegate topViewController].view);
                }
            }
            fail();
            return;
        }
        
        if (isNull(responseObject)) {
            if (bg == NO) {
                NSLog(@"responseObject:%@",responseObject);
                showAndHideWrongJuHua(@"返回空数据", [rootDelegate topViewController].view);
            }
            fail();
            return;
        }
        
        succeed(response,responseObject);
    }] resume];
}

@end
