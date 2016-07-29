//
//  XZLocationServer.h
//  Location(定位)
//
//  Created by 李雪智 on 16/6/14.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, XZServerStatus) {
    LocationStatus_Locating,
    LocationStatus_Located,
    LocationStatus_NoPermission,
    LocationStatus_NotDetermined,
};

@protocol LocationServiceDelegate <NSObject>

- (void)locationChangedWithPlacemark:(CLPlacemark *)placemark;

@end

@interface XZLocationServer : NSObject

@property (nonatomic, assign) XZServerStatus status;
@property (nonatomic, weak) id<LocationServiceDelegate> delegate;

+ (instancetype)shareManager;

- (void)needLoaction; //用户调用

@end
