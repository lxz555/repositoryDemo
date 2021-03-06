//
//  AppDelegate.m
//  RepositoryDemo
//
//  Created by 李雪智 on 16/4/28.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "XZHotFixServer.h"

@interface AppDelegate () <XZHotFixEncryptionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController *rootVC = [[RootViewController alloc] init];
    rootVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    rootVC.view.backgroundColor = ColorFFFFFF;
    
    XZHotFixServer *hotFixServer = [XZHotFixServer sharedService];
    hotFixServer.delegate = self;
    [XZHotFixServer debugEnable:YES];
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"TestJSPatch" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:pathStr encoding:NSUTF8StringEncoding error:nil];
    [XZHotFixServer evaluateScript:script];
    
    self.window.rootViewController = rootVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - hotfix delegate

- (NSString *)encypt:(NSString *)plainText
{
    return plainText;
}

- (NSString *)decypt:(NSString *)encyptText
{
    return encyptText;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
