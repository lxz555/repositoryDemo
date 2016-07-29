//
//  XZLocationModel.h
//  Location(定位)
//
//  Created by 李雪智 on 16/7/11.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLocationModel : NSObject <NSCoding>

//省份
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *pinyin;

+ (XZLocationModel *)currentProvince;
+ (XZLocationModel *)defaultProvinceModel;
- (void)synchronizeCurrentProvince;

@end
