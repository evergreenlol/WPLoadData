//
//  LoadDataModel.h
//  iOSStartDemo
//
//  Created by lolevergreen on 16/6/30.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef NS_ENUM(NSInteger,infoURL){
    Mine_Login,// 登陆
    Mine_Token,// 获取token
};
@protocol loadDataDelegate <NSObject>
/*
 *返回请求数据
 */
- (void)loadSucessed:(id)date andTag:(infoURL)tag withURL:(NSString*)urlStr;
- (void)loadFailed:(NSError*)error andTag:(infoURL)tag withURL:(NSString*)urlStr;
@end

@interface WPLoadData : NSObject
{
    NSOperationQueue * queue;
    NSMutableURLRequest * request;
}
+(instancetype)loadShareInstance;
@property(nonatomic,weak)id<loadDataDelegate> delegate;
/*
type 请求类型
*/
- (void)getUrlLoad:(NSString *)type withURL:(NSString*)url andLoadDelegate:(id<loadDataDelegate>)myDelegate withTag:(infoURL)tag andDic:(id)dic;
/*
 parm 出入的字典用于拼接参数
 type 即为类型参数
 */
+ (NSString*)setValueWithDic:(NSDictionary*)param andInfoURL:(NSString*)infoStr;
/*
 parm 传入的参数  infostr 传入的要拼接的地址
*/
+ (NSString*)setValueWithArr:(NSArray *)param withURL:(NSString*)baseURL andInfoURL:(NSString *)infoStr;

//拼接地址
- (NSString*)appendUrlWithType:(infoURL)urlType;


@end
