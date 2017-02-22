//
//  四舍五入.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/10.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef _____h
#define _____h


/*!
 *  @brief 四舍五入
 *
 *  @param price    需要处理的数字，
 *  @param position 保留小数点第几位，
 *
 *  @return 转换后的结果
 */
- (NSString *)notRounding:(float)price afterPoint:(int)position {
    
    //    NSRoundDown代表的就是 。
    //    scale的参数position代表保留小数点后几位。
    
    /*
     讲述下参数的含义:
     RoundingMode: 简单讲就是你要四舍五入操作的标准.
     // 原始数据
     //    值 1.2  1.21  1.25  1.35  1.27
     各个model转换后的值
     // Plain  (四舍五入)  1.2  1.2   1.3   1.4   1.3
     // Down   (只舍不入)  1.2  1.2   1.2   1.3   1.2
     // Up     (只入不舍)  1.2  1.3   1.3   1.4   1.3
     // Bankers(       )  1.2  1.2   1.2   1.4   1.3
     
     scale : 需要保留的精度。
     raiseOnExactness : 为YES时在处理精确时如果有错误，就会抛出异常。
     raiseOnOverflow  : YES时在计算精度向上溢出时会抛出异常，否则返回。
     raiseOnUnderflow : YES时在计算精度向下溢出时会抛出异常，否则返回.
     raiseOnDivideByZero : YES时。当除以0时会抛出异常，否则返回。
     */
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


#endif /* _____h */
