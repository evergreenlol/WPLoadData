//
//  ViewController.m
//  RequestModel
//
//  Created by lolevergreen on 17/3/6.
//  Copyright © 2017年 lolevergreen. All rights reserved.
//

#import "ViewController.h"
#import "WPLoadData.h"
@interface ViewController ()<loadDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     *使用方法演示
     */
    NSDictionary * logDict;
    NSDictionary * tokenDict;
    NSString     * logUrl;
    NSString     * tokenUrl;
    
    [[WPLoadData loadShareInstance]getUrlLoad:@"POST" withURL:logUrl andLoadDelegate:self withTag:Mine_Login andDic:logDict];
    [[WPLoadData loadShareInstance]getUrlLoad:@"POST" withURL:tokenUrl andLoadDelegate:self withTag:Mine_Token andDic:tokenDict];
}
//返回结果
- (void)loadSucessed:(id)date andTag:(infoURL)tag withURL:(NSString *)urlStr{
    if (tag == Mine_Login) {
        NSDictionary * dict = [date objectForKey:@""];
        NSLog(@"%@",dict);
    }else{
        NSDictionary * dict = [date objectForKey:@""];
        NSLog(@"%@",dict);
    }
}

- (void)loadFailed:(NSError *)error andTag:(infoURL)tag withURL:(NSString *)urlStr{
    NSLog(@"%@",error);
}


@end
