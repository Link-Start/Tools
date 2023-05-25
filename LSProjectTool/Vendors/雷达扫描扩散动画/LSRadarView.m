//
//  LSRadarView.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/5/9.
//  Copyright © 2022 Link-Start. All rights reserved.
//

#import "LSRadarView.h"

#define kCenterX self.bounds.size.width*0.5
#define kCenterY self.bounds.size.height*0.5

#define kDefaultRadarLineColor [UIColor colorWithWhite:1 alpha:0.7]
#define kDefaultStartColor [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]
#define kDefaultEndColor [UIColor colorWithRed:1 green:1 blue:1 alpha:0]

#define kDefaultCircleColor [UIColor colorWithWhite:1 alpha:0.5]


@interface LSRadarView ()

#pragma mark - 扫描类型的 RadarView 属性

/// 扇形半径
@property (nonatomic, assign) CGFloat sectorRadius;
/// 扇形角度
@property (nonatomic, assign) NSInteger angle;
/// 雷达 空心圆圈的数量
@property (nonatomic, assign) NSInteger radarLineNum;
/// 中心 空心圆的半径（一般 这里放置一个圆形的头像）
@property (nonatomic, assign) NSInteger hollowRadius;

#pragma mark - 扩散类型的 RadarView 属性

/// 扩散动画 起始的半径
@property (nonatomic, assign) CGFloat startRadius;
/// 扩散动画 结束的半径
@property (nonatomic, assign) CGFloat endRadius;
/// 圆圈的颜色
@property (nonatomic, strong) UIColor *circleColor;

@property (nonatomic, weak) NSTimer *r_timer;

/// 类型：雷达扫描、水波纹/扩散  动画
@property (nonatomic, assign) LSRadarViewType radarViewType;



@end

@implementation LSRadarView

+ (LSRadarView *)scanRadarViewWithRadius:(CGFloat)radius angle:(int)angle radarLineNum:(int)radarLineNum hollowRadius:(CGFloat)hollowRadius {
    return [[self alloc] initWithRadius:radius angle:angle radarLineNum:radarLineNum hollowRadius:hollowRadius];;
}

- (instancetype)initWithRadius:(CGFloat)radius angle:(int)angle radarLineNum:(int)radarLineNum hollowRadius:(CGFloat)hollowRadius {
    
    self = [super self];
    if (self) {
        self.radarViewType = LSRadarViewTypeScan;
        self.sectorRadius = radius;
        self.frame = CGRectMake(0, 0, radius*2, radius*2);
        self.angle = angle;
        self.radarLineNum = radarLineNum - 1;
        self.hollowRadius = hollowRadius;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+ (LSRadarView *)diffuseRadarViewWithStartRadius:(CGFloat)startRadius endRadius:(CGFloat)endRadius circleColor:(UIColor *)circleColor {
    return [[self alloc] initWithStartRadius:startRadius endRadius:endRadius circleColor:circleColor];;
}

- (instancetype)initWithStartRadius:(CGFloat)startRadius endRadius:(CGFloat)endRadius circleColor:(UIColor *)circleColor {
    self = [super init];
    if (self) {
        self.radarViewType = LSRadarViewTypeDiffuse;
        self.frame = CGRectMake(0, 0, endRadius*2, endRadius*2);
        self.startRadius = startRadius;
        self.endRadius = endRadius;
        self.circleColor = circleColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (_radarViewType == LSRadarViewTypeScan) {
        if (!_startColor) {
            _startColor = kDefaultStartColor;
        }
        if (!_endColor) {
            _endColor = kDefaultEndColor;
        }
        if (!_radarLineColor) {
            _radarLineColor = kDefaultRadarLineColor;
        }
        // 画雷达线
        [self drawRadarLine];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 把要画的扇形 分开画，一次画 1°， 每次的颜色渐变
        for (int i = 0; i < _angle; i++) {
            UIColor *color = [self colorWithCurrentAngleProportion:i*1.0/_angle];
            // 画扇形
            [self drawSectorWithContext:context color:color startAngle:(-90-i)];
        }
    }
}

/// 画扇形
- (void)drawSectorWithContext:(CGContextRef)context color:(UIColor *)color startAngle:(CGFloat)startAngle {
    // 画扇形，也就是画圆，只不过是设置角度的带小，形成一个扇形
    CGContextSetFillColorWithColor(context, color.CGColor);// 填充色
    CGContextSetLineWidth(context, 0); //线的宽度
    // 以 self.radius 为半径围绕圆心画指定角度的扇形
    CGContextMoveToPoint(context, kCenterX, kCenterY);
    CGContextAddArc(context, kCenterX, kCenterY, _sectorRadius, (startAngle*M_PI/180), ((startAngle-1)*M_PI/180), 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
}

/// 画雷达线
- (void)drawRadarLine {
    CGFloat minRadius = (_sectorRadius - _hollowRadius) * (pow(0.618, _radarLineNum - 1));
    // 画 围着空心半径的第一个空心圆，此圆不在计数内
    [self drawLineWithRadius:(_hollowRadius+minRadius*0.382)];
    
    for (int i = 0; i < _radarLineNum; i++) {
        // 画空心圆
        [self drawLineWithRadius:(_hollowRadius + minRadius/pow(0.618, i))];
    }
}

/// 画空心圆
- (void)drawLineWithRadius:(CGFloat)radius {
    CAShapeLayer *solidLine = [CAShapeLayer layer];
    CGMutablePathRef solidPath = CGPathCreateMutable();
    solidLine.lineWidth = 1.0f;
    solidLine.strokeColor = _radarLineColor.CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(self.bounds.size.width*0.5-radius, self.bounds.size.height*0.5-radius, radius*2, radius*2));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.layer addSublayer:solidLine];
}

- (UIColor *)colorWithCurrentAngleProportion:(CGFloat)angleProportion {
    NSArray *startRGBA = [self RGBA_WithColor:_startColor];
    NSArray *endRGBA = [self RGBA_WithColor:_endColor];
    CGFloat currentR = [startRGBA[0] floatValue] - ([startRGBA[0] floatValue] - [endRGBA[0] floatValue]) * angleProportion;
    CGFloat currentG = [startRGBA[1] floatValue] - ([startRGBA[1] floatValue] - [endRGBA[1] floatValue]) * angleProportion;
    CGFloat currentB = [startRGBA[2] floatValue] - ([startRGBA[2] floatValue] - [endRGBA[2] floatValue]) * angleProportion;
    CGFloat currentA = [startRGBA[3] floatValue] - ([startRGBA[3] floatValue] - [endRGBA[3] floatValue]) * angleProportion;

    return [UIColor colorWithRed:currentR green:currentG blue:currentB alpha:currentA];
}

/// 将UIColor 对象解析成RGBA 值 的数组
/// @param color UIColor对象，由RGBA值 初始化的 [UIColor colorWithRed:rValue green:gValue blue:bValue alpha:aValue]
/// @return 包含 RGBA 值的数组 [rValue，gValue，bValue，aValue]
- (NSArray *)RGBA_WithColor:(UIColor *)color {
    NSString *colorStr =  [NSString stringWithFormat:@"%@", color];
    // 将RGB值描述 分隔成字符串
    NSArray *colorValueArray = [colorStr componentsSeparatedByString:@" "];
    NSString *R = colorValueArray[1];
    NSString *G = colorValueArray[2];
    NSString *B = colorValueArray[3];
    NSString *A = colorValueArray[4];
    
    return @[R, G, B, A];
}

#pragma mark - 展示
- (void)showTargetView:(UIView *)targetView {
    self.center = targetView.center;
    [targetView addSubview:self];
}
- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - 开始动画
- (void)startAnimation {
    if (_radarViewType == LSRadarViewTypeScan) { //雷达扫描
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:(1 * M_PI * 2.0)];
        rotationAnimation.duration = 2;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INT_MAX;
        [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    } else { // 水波纹扩散动画
        [self diffuseAnimation];
        if (!_r_timer) {
            NSTimer *r_time = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(diffuseAnimation) userInfo:nil repeats:YES];
            _r_timer = r_time;
        } else {
            NSLog(@"水波纹扩散动画 __ 已经有定时器");
        }
        
    }
}

/// 水波纹扩散动画
- (void)diffuseAnimation {
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [self drawCircle]; //画圆
    imgV.frame = CGRectMake(0, 0, _startRadius, _startRadius);
    imgV.center = CGPointMake(kCenterX, kCenterY);
    [self addSubview:imgV];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        imgV.frame = CGRectMake(0, 0, self.endRadius*2, self.endRadius*2);
        imgV.center = CGPointMake(kCenterX, kCenterY);
        imgV.alpha = 0;
    } completion:^(BOOL finished) {
        [imgV removeFromSuperview];
    }];
}

/// 画圆
- (UIImage *)drawCircle {
    UIGraphicsBeginImageContext(CGSizeMake(_endRadius*2, _endRadius*2));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, kCenterX, kCenterY);
    CGContextSetFillColorWithColor(context, _circleColor.CGColor);
    CGContextAddArc(context, kCenterX, kCenterY, _endRadius, 0, -2*M_PI, 1);
    CGContextFillPath(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark - 结束动画
- (void)stopAnimation {
    if (_radarViewType == LSRadarViewTypeScan) {
        [self.layer removeAnimationForKey:@"rotationAnimation"];
    } else {
        [_r_timer invalidate];
        _r_timer = nil;
    }
}





@end
