//
//  UIColor+Hex.h
//  色值的转化
//
//  Created by 李雪智 on 16/1/19.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 *  16进制字符串转化为颜色
 *  @param hexStr 16进制字符串 支持@"0x..." @"0X..." @"#..." @"..."
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;
/**
 *  16进制字符串转化为颜色
 *  @param hexStr 16进制字符串
 *  @param alpha  透明度
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(NSInteger)alpha;


/**
 *  16进制色值转化颜色
 *  @param hexInteger 16进制色值
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(NSInteger)hexInteger;
/**
 *  16进制色值转化颜色
 *  @param hexInteger 16进制色值
 *  @param alpha      透明度
 *  @return UIColor
 */
+ (UIColor *)colorWithHex:(NSInteger)hexInteger alpha:(NSInteger)alpha;

@end
