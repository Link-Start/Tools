//
//  SignatureDrawingView.m
//  MYYProject
//
//  Created by mac on 2018/7/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SignatureDrawingView.h"

@interface SignatureDrawingView ()
/// 记录签名完成后生成的签名图片
@property(nonatomic, strong) UIImage *saveImgView;

/// 声明一条贝塞尔曲线
@property(nonatomic, strong) UIBezierPath *bezier;
/// 创建一个存储后退操作记录的数组
@property(nonatomic, strong) NSMutableArray *cancleArr;

@end

@implementation SignatureDrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDrawingView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// 初始化一些参数
- (void)initDrawingView {
    self.color = [UIColor blackColor];
    self.lineWidth = 1;
    self.allLines = [NSMutableArray new];
    self.cancleArr = [NSMutableArray new];
}

// 触摸开始、开始划线
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 贝塞尔曲线
    self.bezier = [UIBezierPath bezierPath];
    
    // 获取触摸的点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 设置贝塞尔起点
    [self.bezier moveToPoint:point];
    
    // 在字典保存每条线的数据
    NSMutableDictionary *tempDic = [NSMutableDictionary new];
    [tempDic setObject:self.color forKey:@"color"];
    [tempDic setObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"lineWidth"];
    [tempDic setObject:self.bezier forKey:@"line"];
    
    // 存入线
    [self.allLines addObject:tempDic];
}

//当划线的时候把点存储到BezierPath中
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.bezier addLineToPoint:point];
    //重绘界面
    [self setNeedsDisplay];
}

// 画出线条
- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < self.allLines.count; i++) {
        
        NSDictionary *temDic = self.allLines[i];
        UIColor *color = temDic[@"color"];
        CGFloat width = [temDic[@"lineWidth"] floatValue];
        UIBezierPath *path = temDic[@"line"];
        
        [color setStroke];
        [path setLineWidth:width];
        [path stroke];
    }
}

//上一步、后退一步
- (void)doBack {
    if (self.allLines.count > 0) {
        NSInteger index = self.allLines.count - 1;
        [self.cancleArr addObject:self.allLines[index]];
        [self.allLines removeObjectAtIndex:index];
        [self setNeedsDisplay];
    }
}

// 下一步
- (void)doForward {
    if (self.cancleArr.count > 0) {
        NSInteger index = self.cancleArr.count - 1;
        [self.allLines addObject:self.cancleArr[index]];
        [self.cancleArr removeObjectAtIndex:index];
        [self setNeedsDisplay];
    }
}

// 清除所有
- (void)clearAllLines {
    if (self.allLines.count > 0) {
        [self.cancleArr removeAllObjects];
        [self.allLines removeAllObjects];
        [self setNeedsDisplay];
    }
}

//保存图片进入相册
- (void)saveImage:(void(^)(UIImage * signature))saveSuccessBlock {
    if (self.allLines.count != 0) {
        // 截屏
        UIGraphicsBeginImageContext(self.bounds.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 截取画板尺寸
        CGImageRef sourceImageRef = [image CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
        self.saveImgView = [UIImage imageWithCGImage:newImageRef];
        
        // 截图保存相册
        //    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
        
        NSLog(@"签名结束，生成签名图片成功");
        
        if (saveSuccessBlock) {
            saveSuccessBlock(self.saveImgView);
        }
    } else {
        self.saveImgView = nil;
        NSLog(@"没有签名!!!");
    }
}

@end
