//
//  LoadDataModel.m
//  iOSStartDemo
//
//  Created by lolevergreen on 16/6/30.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "WPLoadData.h"
@implementation WPLoadData

+(instancetype)loadShareInstance{
    static WPLoadData *model = nil;
//    static dispatch_once_t predicta;
//    dispatch_once(&predicta, ^{
        model = [[WPLoadData alloc] init];
//    });
    return model;

}
-(instancetype)init{
    if (self ==[super init]) {
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}
/*
 *请求部分
 *type:请求类型，post或者get...
 *url:链接；
 *delegate:返回成功或失败的方法
 *tag:标签，用于不同请求的判断
 *dic:所需传送的值
 */
- (void)getUrlLoad:(NSString *)type withURL:(NSString *)url andLoadDelegate:(id<loadDataDelegate>)myDelegate withTag:(infoURL)tag andDic:(id)dic{
    self.delegate = myDelegate;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([type isEqualToString:@"GET"]) {
        [manager GET:url parameters:dic  progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadSucessed:andTag:withURL:)]) {
                [self.delegate loadSucessed:responseObject andTag:tag withURL:url];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(loadFailed:andTag:withURL:)]) {
                [self.delegate loadFailed:error andTag:tag withURL:url];
            }
        }];
    }else if ([type isEqualToString:@"POST"]){
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadSucessed:andTag:withURL:)]) {
                [self.delegate loadSucessed:responseObject andTag:tag withURL:url];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(loadFailed:andTag:withURL:)]) {
                [self.delegate loadFailed:error andTag:tag withURL:url];
            }
        }];
    }else{//上传图片
        UIImage *eachImage = [dic objectForKey:@"image"];
        NSString *imageName = [dic objectForKey:@"imageType"];
        [dic removeObjectForKey:@"imageType"];
        [dic removeObjectForKey:@"image"];
        
        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *eachImgData = UIImageJPEGRepresentation(eachImage, 0.1);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:eachImgData name:imageName fileName:fileName mimeType:@"image/jpeg"];
            
        }progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印进度
            NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
      }];
    }
}
/*
 *用于拼接字典
 */
+(NSString*)setValueWithDic:(NSDictionary*)param andInfoURL:(NSString*)infoStr{
    
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:0];
    [urlStr appendString:infoStr];
    [urlStr appendString:@"?"];
    for (int i=0; i<[param count]; i++) {
        NSString *key = [param.allKeys objectAtIndex:i];
        NSString *vlue = [param objectForKey:key];
        if ([vlue isKindOfClass:[NSNumber class]]) {
            NSNumber *value = (NSNumber *)vlue;
            vlue = [value stringValue];
        }
        if (i!=0) {
            [urlStr appendString:@"&"];
        }
        [urlStr appendFormat:@"%@=%@",key,vlue];
    }
    return urlStr;
}
/*
 *用于拼接数组
 */
+(NSString*)setValueWithArr:(NSArray *)param withURL:(NSString*)baseURL andInfoURL:(NSString *)infoStr{
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:0];
    [urlStr appendString:baseURL];
    [urlStr appendString:infoStr];
    for (int i=0; i<[param count]; i++) {
        NSString *value = [param objectAtIndex:i];
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *nuberValue =(NSNumber*)value;
            value = [nuberValue stringValue];
        }
        [urlStr appendString:value];
        if (i!=[param count]-1) {
            [urlStr appendString:@"/"];
        }
    }
    return urlStr;
}
/*
 *在此填写枚举所对应的链接
 */
- (NSString *)getBaseUrl:(infoURL)urlType{
    NSString *urlStr = nil;
    switch (urlType) {
        case Mine_Login :{
            urlStr = @"suantech/token/login";
        }break;
        case Mine_Token:{
            urlStr = @"suantech/token/getToken";
        }break;
        default:
        break;
    }
    return urlStr;
}

/*
 *用于链接地址的拼接
 */
- (NSString*)appendUrlWithType:(infoURL)urlType{
    NSString * KPIBaseURL ;
    NSMutableString *urlString =[NSMutableString stringWithCapacity:0];
    [urlString appendString:KPIBaseURL];
    [urlString appendString:[self getBaseUrl:urlType]];
    return urlString;
}

@end
