//
//  XZLocationServer.m
//  Location(定位)
//
//  Created by 李雪智 on 16/6/14.
//  Copyright © 2016年 李雪智. All rights reserved.
//

/**
 *  ios6开始访问隐私方面如位置，通讯录，日历，相机，相册等要用户授权，
 */
#import <UIKit/UIKit.h>
#import "XZLocationServer.h"
#import <CoreLocation/CoreLocation.h>

@interface XZLocationServer () <CLLocationManagerDelegate>

/**
每隔多少米定位一次
@property (nonatomic, assign) CLLocationDistance distanceFilter;
定位精确度（越精确就越耗电）
@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;
 
 */

@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lon;
@property (nonatomic, strong) CLPlacemark *placemark;  //定位的信息
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;
@property (nonatomic, copy) NSString *address;

/** 用户位置管理者对象 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/**编码使用的对象*/
@property (strong, nonatomic) CLGeocoder *geoCoder;

@end

@implementation XZLocationServer

+ (instancetype)shareManager {
    static XZLocationServer *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[XZLocationServer alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _geoCoder = [[CLGeocoder alloc] init];
        self.lat = 0;
        self.lon = 0;
        self.address = nil;
        self.lastUpdateTime = 0;
        self.status = LocationStatus_Locating;
    }
    return self;
}

- (void)needLoaction {
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
       || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
#warning mark -- 还需要校验系统的时间 --
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        if ((nowTime - self.lastUpdateTime) > 60 * 60 * 6) {
            if (self.status != LocationStatus_Locating) {
                if ([_delegate respondsToSelector:@selector(locationChangedWithPlacemark:)]) {
                    [_delegate locationChangedWithPlacemark:nil];
                }
                [self start];
            }
            [self start];
            return;
        } else {
            // 防止placemark没有被解析出来(需要网络)，经纬度有可能缓存
            if (!self.placemark) {
                //反地理编码
                CLLocation *location=[[CLLocation alloc]initWithLatitude:self.lat longitude:self.lon];
                [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                    CLPlacemark *placemark=[placemarks firstObject];
                    self.placemark = placemark;
                    
                    if ([_delegate respondsToSelector:@selector(locationChangedWithPlacemark:)]) {
                        [_delegate locationChangedWithPlacemark:self.placemark];
                    }
                }];
                
                return;
            }
            
            if ([_delegate respondsToSelector:@selector(locationChangedWithPlacemark:)]) {
                [_delegate locationChangedWithPlacemark:self.placemark];
            }
            return;
        }
    } else if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        self.status = LocationStatus_NoPermission;
        if ([_delegate respondsToSelector:@selector(locationChangedWithPlacemark:)]) {
            [_delegate locationChangedWithPlacemark:nil];
        }
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            
            if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0) {
                [self start];
            }
        }
    }
}

- (void)start {
    /**
     默认情况是这样的,每当位置改变时Location Manager就调用一次代理。
     通过设置distance filter可以实现当位置改变超出一定范围时Location Manager才调用相应的代理方法。这样可以达到省电的目的。
     例如：locationManager.distanceFilter = 1000.0f;
     如果设置默认值：locationManager.distanceFilter = kCLDistanceFilterNone;
     */
    
    self.status = LocationStatus_Locating;
    //设置定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance = 10.0; //十米定位一次 CLLocationDistance-->就是double
    _locationManager.distanceFilter = distance;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation 代理

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject]; //取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate; //位置坐标
    [self getAddressWithCoordinate:coordinate];
    
    //如果不需要实时定位，使用结束之后关闭定位服务
    [_locationManager stopUpdatingHeading];
}

-(void)getAddressWithCoordinate:(CLLocationCoordinate2D) coordinate {
    CLLocationDegrees latitude = coordinate.latitude;  //CLLocationDegrees-->就是double
    CLLocationDegrees longitude = coordinate.longitude;
    
    self.status = LocationStatus_Located;
    self.lat = latitude;
    self.lon = longitude;

    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placemark = [placemarks firstObject];
#warning mark -- 还需要校验系统的时间 --
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        self.lastUpdateTime = nowTime;
        if (_delegate && [_delegate respondsToSelector:@selector(locationChangedWithPlacemark:)]) {
            [_delegate locationChangedWithPlacemark:self.placemark];
        }
    }];
}

//当改变权限设置的时候的操作。
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self start];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self start];
            break;
        case kCLAuthorizationStatusDenied:
            self.status = LocationStatus_NotDetermined;
            break;
        default:
            break;
    }
}

@end
