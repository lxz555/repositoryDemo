//
//  XZHotFixServer.m
//  RepositoryDemo
//
//  Created by 李雪智 on 16/7/12.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import "XZHotFixServer.h"
#import "JPEngine.h"

#define DebugLog(format, args...)  if (sDebugflag) NSLog(format, ##args);

static BOOL sDebugFlag;

static NSString * sHotFixFilePath;
static NSString * const sHotFixFilename = @"f.x";

@interface XZHotFixServer ()

@property (nonatomic, assign) BOOL engineIntialized;

@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSNumber *hotFixVersion;

@end

@implementation XZHotFixServer

+ (instancetype)sharedService
{
    static dispatch_once_t oncePredicate;
    static XZHotFixServer *instance = nil;
    dispatch_once(&oncePredicate, ^{
        instance = [[XZHotFixServer alloc] init];
    });
    
    return instance;
}

+ (void)startWithApi:(NSString *)apiUrl
{
    // 设置获取配置的apiUrl。同时会去拉取一下最新补丁
    [XZHotFixServer sharedService].apiUrl = apiUrl;
    
    [self startEngine];
    
    [self checkHotFix];
}

+ (void)startEngine
{
    if ([XZHotFixServer sharedService].engineIntialized) {
        return;
    }
    
    [JPEngine startEngine];
    [XZHotFixServer sharedService].engineIntialized = YES;
}


+ (void)checkHotFix
{
    NSString *apiUrl = [XZHotFixServer sharedService].apiUrl;
    if (!apiUrl.length) {
        return;
    }
    
    // app版本号，like: 2.3.5
    NSString *appVersion = [XZHotFixServer sharedService].appVersion;
    
    // 版本号为递增的整数
    NSNumber *hotFixVersion = [XZHotFixServer sharedService].hotFixVersion;
    if (!hotFixVersion) {
        hotFixVersion = @0;
    }
    
    NSDictionary *paramDict = @{@"app_version":appVersion};
    
    // 检查是否有补丁(通过appVersion & hotFixVersion进行检查)
    // 此处会依赖咱们得network库
//    [[HBNetworkEngine sharedEngine] getRequestWithUrl:apiUrl params:paramDict CompleteBlock:^(HBResponseModel *result) {
//        NSData *data = result.responseData;
//        if([data length] > 0) {
//            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            if (responseObject) {
//                NSNumber *newVersion = responseObject[@"hotfix_version"];
//                NSString *hotfixUrl = responseObject[@"hotfix_url"];
//                if (newVersion && newVersion.integerValue > hotFixVersion.integerValue) {
//                    // 下载js修复文件并执行
//                    [self downloadHotfix:hotfixUrl version:newVersion];
//                    return;
//                }
//                
//                // hotfixVersion未发生改变，直接使用本地的内容
//                if (hotFixVersion.integerValue > 0) {
//                    [self evaluateLocalFile];
//                }
//            }
//        }
//        
//    } errorBlock:^(id error) {
//        
//    }];
    
    [self evaluateLocalFile];
}

+ (BOOL)evaluateLocalFile
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self hotFixFilePath]]) {
        return NO;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[self hotFixFilePath]];
    return [self evaluateLocalData:data];
}

+ (NSString *)hotFixFilePath
{
    if (sHotFixFilePath == nil) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        sHotFixFilePath = [documentPath stringByAppendingPathComponent:sHotFixFilename];
    }
    
    return sHotFixFilePath;
}

// 执行本地加密内容
+ (BOOL)evaluateLocalData:(NSData *)data
{
    if (![data length]) {
        return NO;
    }
    
    // 解密数据
    NSString *script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([XZHotFixServer sharedService].delegate) {
        script = [[XZHotFixServer sharedService].delegate decypt:script];
    }
    if (!script.length) {
//        DebugLog(@"patch数据解密失败");
        return NO;
    }
    
    [JPEngine evaluateScript:script];
//    DebugLog(@"[hotfix] evaluate local script:\n%@", script);
    return YES;
}

+ (void)evaluateScript:(NSString *)script
{
    [self startEngine];
    
    [JPEngine evaluateScript:script];
}

+ (void)debugEnable:(BOOL)enable
{
    sDebugFlag = enable;
}

@end
