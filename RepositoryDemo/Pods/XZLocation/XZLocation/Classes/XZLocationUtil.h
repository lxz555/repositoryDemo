//
//  XZLocationUtil.h
//  Location(定位)
//
//  Created by 李雪智 on 16/7/11.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLocationUtil : NSObject

/**
 *  根据省名查找ID
 *
 *  @param provinceName 省名称
 *
 *  @return 省ID
 */
+ (NSNumber *)regionIdForProvinceName:(NSString *)provinceName;

@end
