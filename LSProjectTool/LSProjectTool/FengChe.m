//
//  FengChe.m
//  LSProjectTool
//
//  Created by Xcode on 16/12/16.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "FengChe.h"

@implementation FengChe

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    CGFloat pathWidth = self.frame.size.width;
    CGFloat pathHeight = self.frame.size.height;
    
    
    //设置颜色红色
    UIColor *color = [UIColor redColor];
    
    [color set];
    
    //初始化贝塞尔,绘制上半个风车
    UIBezierPath *mPath = [[UIBezierPath alloc] init];
    mPath.lineWidth = 5;//线条宽度
    mPath.lineCapStyle = kCGLineCapRound;//拐角
    mPath.lineJoinStyle = kCGLineCapRound;//终点
    [mPath moveToPoint:CGPointMake(pathWidth / 8, pathHeight / 2)];//起点
    
    //前一个参数是终点，后一个参数是控制点
    [mPath addQuadCurveToPoint:CGPointMake(pathWidth / 2, pathHeight / 2) controlPoint:CGPointMake(pathWidth / 4, pathHeight / 4)];
    
    [mPath addQuadCurveToPoint:CGPointMake(pathWidth / 8 * 7, pathHeight / 2) controlPoint:CGPointMake(pathWidth / 4 * 3, pathHeight / 4 * 3)];
    
    [mPath fill];//填充色
    
    [mPath closePath]; //闭合
    [mPath stroke];//边框填充
    
    //绘制 下半个 风车
    UIBezierPath *nPath = [[UIBezierPath alloc] init];
    nPath.lineWidth = 5;//线宽
    nPath.lineCapStyle = kCGLineCapRound;//拐点
    nPath.lineJoinStyle = kCGLineCapRound;//终点
    
    [nPath moveToPoint:CGPointMake(120, 50)];//起点
    //
    [nPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(150, 75)];
    [nPath addQuadCurveToPoint:CGPointMake(120, 150) controlPoint:CGPointMake(75, 125)];
    
    [nPath fill];
    
    
    [nPath closePath]; //闭合
    [nPath stroke];//边框填充
}


@end
