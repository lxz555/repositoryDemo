
//
//  UIColor+Hex.m
//  色值的转化
//
//  Created by 李雪智 on 16/1/19.
//  Copyright © 2016年 李雪智. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

/**
 *  16进制字符串转化为颜色   strtoul一个c函数，可以自动解析
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr {
    //字符串去除两端空格，变大写
    NSString *colorStr = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //至少6位
    if (colorStr.length < 6) {
        return [UIColor clearColor];
    }
    //进一步判断，处理
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    if (colorStr.length < 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.length = 2;
    //R
    range.location = 0;
    NSString *rString = [colorStr substringWithRange:range];
    //G
    range.location = 2;
    NSString *gString = [colorStr substringWithRange:range];
    //B
    range.location = 4;
    NSString *bString = [colorStr substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:bString] scanHexInt:&g];
    [[NSScanner scannerWithString:gString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0) green:((float)g / 255.0) blue:((float)b / 255.0) alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(NSInteger)alpha {
    //字符串去除两端空格，变大写
    NSString *colorStr = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //至少6位
    if (colorStr.length < 6) {
        return [UIColor clearColor];
    }
    //进一步判断，处理
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    if (colorStr.length < 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.length = 2;
    //R
    range.location = 0;
    NSString *rString = [colorStr substringWithRange:range];
    //G
    range.location = 2;
    NSString *gString = [colorStr substringWithRange:range];
    //B
    range.location = 4;
    NSString *bString = [colorStr substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:bString] scanHexInt:&g];
    [[NSScanner scannerWithString:gString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0) green:((float)g / 255.0) blue:((float)b / 255.0) alpha:alpha];
}


/**
 *  16进制色值转化颜色
 */
+ (UIColor *)colorWithHex:(NSInteger)hexInteger {
    return [UIColor colorWithRed:((float)((hexInteger & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexInteger & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexInteger & 0xFF)) alpha:1];
}

+ (UIColor *)colorWithHex:(NSInteger)hexInteger alpha:(NSInteger)alpha {
    return [UIColor colorWithRed:((float)((hexInteger & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexInteger & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexInteger & 0xFF)) alpha:alpha];
}

@end
