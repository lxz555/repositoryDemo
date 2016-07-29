//
//  XZLocationModel.m
//  Location(定位)
//
//  Created by 李雪智 on 16/7/11.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import "XZLocationModel.h"

static NSString *const XZLocationModelKey = @"XZLocationModelKey";

@implementation XZLocationModel

+ (XZLocationModel *)currentProvince {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:XZLocationModelKey]];
}

+ (XZLocationModel *)defaultProvinceModel {
    XZLocationModel *model = [[XZLocationModel alloc] init];
#warning mark - 根据具体与后台的约定而定 -
    //默认全国，id为0
    model.provinceName = @"全国";
    model.provinceId = @"0";
    return model;
}

- (void)synchronizeCurrentProvince {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:XZLocationModelKey];
    [userDefaults synchronize];
}

#pragma mark - NSCoding -

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
    self.provinceName = [aDecoder decodeObjectForKey:@"provinceName"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
    [aCoder encodeObject:self.provinceName forKey:@"provinceName"];
}


@end
