//
//  XZHotFixServer.h
//  RepositoryDemo
//
//  Created by 李雪智 on 16/7/12.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XZHotFixEncryptionDelegate <NSObject>
@required
- (NSString *)encypt:(NSString *)plainText;
- (NSString *)decypt:(NSString *)encyptText;

@end

@interface XZHotFixServer : NSObject


@property (nonatomic, weak) id<XZHotFixEncryptionDelegate> delegate;

+ (instancetype)sharedService;

/**
 *  开启热补丁服务(启动时调用)
 */
+ (void)startWithApi:(NSString *)apiUrl;

/**
 *  拉取指定版本的hotfix
 */
+ (void)fetchHotFixByVersion:(NSNumber *)hotfixVersion;
+ (void)fetchHotFixByVersion:(NSNumber *)hotfixVersion appVersion:(NSString *)appVersion;

/**
 *  强制检查是否有热补丁，若有则会直接拉取并执行
 */
+ (void)checkHotFix;

/**
 *  执行脚本
 */
+ (void)evaluateScript:(NSString *)script;

/**
 *  开启调试输出
 */
+ (void)debugEnable:(BOOL)enable;

/**
 *  [可选操作]设置hotfix路径(包含文件名)
 */
+ (void)setHotFixFilePath:(NSString *)filePath;


@end
