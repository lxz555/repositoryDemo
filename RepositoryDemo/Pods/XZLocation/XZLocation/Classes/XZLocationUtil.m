//
//  XZLocationUtil.m
//  Location(定位)
//
//  Created by 李雪智 on 16/7/11.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import "XZLocationUtil.h"
#import "FMDB/FMDB.h"

@implementation XZLocationUtil

+ (NSNumber *)regionIdForProvinceName:(NSString *)provinceName
{
    NSNumber *regionId;
    
    // 默认杭州市
    if (!provinceName) {
        provinceName = @"浙江省";
    }
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"location.region" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:pathString];
    
    if (![db open]) {
        return regionId;
    }
    
    NSString *sql = @"SELECT * FROM region WHERE name = ?";
    
    FMResultSet *rs = [db executeQuery:sql, (provinceName?:[NSNull null])];
    
    if ([rs next]) {
        regionId = [rs objectForColumnName:@"id"];
    }
    
    [db close];
    
    return regionId;
}

@end
