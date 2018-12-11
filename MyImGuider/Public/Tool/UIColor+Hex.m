//
//  UIColor+Hex.m
//  ImGuider
//
//  Created by llt on 2017/6/14.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

/// 十六进制转换 + 不透明
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    return [self colorWithHexString:hexString alpha:1.0f];
}

// 十六进制转换 + 透明度
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
}

@end
