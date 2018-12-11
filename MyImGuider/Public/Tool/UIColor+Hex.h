//
//  UIColor+Hex.h
//  ImGuider
//
//  Created by llt on 2017/6/14.
//  Copyright © 2017年 imguider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
