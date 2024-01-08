//
//  UIView+LSCategory.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/6/2.
//  Copyright © 2021 Link-Start. All rights reserved.
//
/*
 在声明property属性后，有2种实现选择
 1
 @synthesize
 编译器期间，让编译器自动生成getter/setter方法。
 当有自定义的存或取方法时，自定义会屏蔽自动生成该方法
 
 2
 @dynamic
 告诉编译器，不自动生成getter/setter方法，避免编译期间产生警告
 然后由自己实现存取方法
 或存取方法在运行时动态创建绑定：主要使用在CoreData的实现NSManagedObject子类时使用，由Core Data框架在程序运行的时动态生成子类属性
 */



#import "UIView+LSCategory.h"

@implementation UIView (LSCategory)

// lx_x
- (void)setLs_x:(CGFloat)ls_x {
    CGRect frame = self.frame;
    frame.origin.x = ls_x;
    self.frame = frame;
}

- (CGFloat)ls_x
{
    return self.frame.origin.x;
}

// ls_y
- (void)setLs_y:(CGFloat)ls_y {
    CGRect frame = self.frame;
    frame.origin.y = ls_y;
    self.frame = frame;
}

- (CGFloat)ls_y
{
    return self.frame.origin.y;
}

// ls_maxX
- (void)setLs_maxX:(CGFloat)ls_maxX {
    self.ls_x = ls_maxX - self.ls_width;
}

- (CGFloat)ls_maxX
{
    return CGRectGetMaxX(self.frame);
}

// lx_maxY
- (void)setLs_maxY:(CGFloat)ls_maxY {
    self.ls_y = ls_maxY - self.ls_height;
}

- (CGFloat)ls_maxY
{
    return CGRectGetMaxY(self.frame);
}

// ls_centerX
- (void)setLs_centerX:(CGFloat)ls_centerX {
    CGPoint center = self.center;
    center.x = ls_centerX;
    self.center = center;
}

- (CGFloat)ls_centerX
{
    return self.center.x;
}

// ls_centerY
- (void)setLs_centerY:(CGFloat)ls_centerY {
    CGPoint center = self.center;
    center.y = ls_centerY;
    self.center = center;
}

- (CGFloat)ls_centerY
{
    return self.center.y;
}

// ls_width
- (void)setLs_width:(CGFloat)ls_width {
    CGRect frame = self.frame;
    frame.size.width = ls_width;
    self.frame = frame;
}

- (CGFloat)ls_width
{
    return self.frame.size.width;
}

// ls_height
- (void)setLs_height:(CGFloat)ls_height {
    CGRect frame = self.frame;
    frame.size.height = ls_height;
    self.frame = frame;
}

- (CGFloat)ls_height
{
    return self.frame.size.height;
}

// ls_size
- (void)setLs_size:(CGSize)ls_size {
    CGRect frame = self.frame;
    frame.size = ls_size;
    self.frame = frame;
}

- (CGSize)ls_size
{
    return self.frame.size;
}

// ls_origin
- (void)setLs_origin:(CGPoint)ls_origin {
    CGRect frame = self.frame;
    frame.origin = ls_origin;
    self.frame = frame;
}

- (CGPoint)ls_origin
{
    return self.frame.origin;
}

// ls_top
- (void)setLs_top:(CGFloat)ls_top {
    CGRect frame = self.frame;
    frame.origin.y = ls_top;
    self.frame = frame;
}

- (CGFloat)ls_top
{
    return self.ls_origin.y;
}

// ls_left
- (void)setLs_left:(CGFloat)ls_left {
    CGRect frame = self.frame;
    frame.origin.x = ls_left;
    self.frame = frame;
}

- (CGFloat)ls_left
{
    return self.ls_origin.x;
}

// ls_right
- (void)setLs_right:(CGFloat)ls_right {
    CGRect frame = self.frame;
    frame.origin.x = ls_right - frame.size.width;
    self.frame = frame;

}

- (CGFloat)ls_right
{
    return self.ls_left + self.ls_width;
}

// ls_bottom
- (void)setLs_bottom:(CGFloat)ls_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ls_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ls_bottom
{
    return self.ls_top + self.ls_height;
}

//////////////////////////////////////////////////////////////bounds accessors
// ls_boundsSize
- (void)setLs_boundsSize:(CGSize)ls_boundsSize {
    CGRect bounds = self.bounds;
    bounds.size = ls_boundsSize;
    self.bounds = bounds;
}

- (CGSize)ls_boundsSize
{
    return self.bounds.size;
}

// ls_boundsWidth
- (void)setLs_boundsWidth:(CGFloat)ls_boundsWidth {
    CGRect bounds = self.bounds;
    bounds.size.width = ls_boundsWidth;
    self.bounds = bounds;
}

- (CGFloat)ls_boundsWidth
{
    return self.ls_boundsSize.width;
}

// ls_boundsHeight
- (void)setLs_boundsHeight:(CGFloat)ls_boundsHeight {
    CGRect bounds = self.bounds;
    bounds.size.height = ls_boundsHeight;
    self.bounds = bounds;
}
- (CGFloat)ls_boundsHeight
{
    return self.ls_boundsSize.height;
}

//ls_contentBounds
- (CGRect)ls_contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.ls_boundsWidth, self.ls_boundsHeight);
}

// ls_contentCenter
- (CGPoint)ls_contentCenter
{
    return CGPointMake(self.ls_boundsWidth/2.0f, self.ls_boundsHeight/2.0f);
}

///水平居中
- (void)ls_alignHorizontal {
    self.ls_x = (self.superview.ls_width - self.ls_width) * 0.5;
}
///垂直居中
- (void)ls_alignVertical {
    self.ls_y = (self.superview.ls_height - self.ls_height) *0.5;
}

/** **/
- (instancetype)ls_with {
    return self;
}

- (instancetype)ls_and {
    return self;
}

/**************************************************************************/
/**
 *  @brief 从Xib加载视图
 */
+ (id)ls_loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *elements = [[NSBundle mainBundle] loadNibNamed:nibName
                                                      owner:nil
                                                    options:nil];
    for ( NSObject *anObject in elements ) {
        if ( [anObject isKindOfClass:[self class]] ) {
            return anObject;
        }
    }
    return nil;
}

/**************************************************************************/
///判断是否显示在主窗口window上面
- (BOOL)ls_isShowOnWindow {
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    //相对于父控件转换之后的rect
    CGRect newRect = [keyWindow convertRect:self.frame fromView:self.superview];
    //主窗口的bounds
    CGRect winBounds = keyWindow.bounds;
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    //判断两个坐标系是否有交汇的地方，返回bool值
    BOOL isIntersects =  CGRectIntersectsRect(newRect, winBounds);
    if (self.hidden != YES && self.alpha >0.01 && self.window == keyWindow && isIntersects) {
        return YES;
    }else{
        return NO;
    }
}

///主控制器
- (UIViewController *)ls_parentController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

// 判断View是否显示在屏幕上
- (BOOL)ls_isDisplayedInScreen {
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}


/// 判断某个点是否在视图区域内，针对 transform 做了转换计算，并提供 UIEdgeInsets 缩放区域的参数
/// @param point  要判断的点坐标
/// @param view   传入的视图，一定要与本视图处于同一视图树中
/// @param insets UIEdgeInsets参数可以调整判断的边界
/// @return BOOL类型，返回点坐标是否位于视图内
- (BOOL)checkPoint:(CGPoint)point inView:(UIView *)view withInsets:(UIEdgeInsets)insets {
     // 将点坐标转化为视图内坐标系的点，消除 transform 带来的影响
    CGPoint convertedPoint = [self convertPoint:point toView:view];
    CGAffineTransform viewTransform = view.transform;
    // 计算视图缩放比例
    CGFloat scale = sqrt(viewTransform.a * viewTransform.a + viewTransform.c * viewTransform.c);
    // 将 UIEdgeInsets 除以缩放比例，以便得到真实的『周围区域』
    UIEdgeInsets scaledInsets = (UIEdgeInsets){insets.top/scale,insets.left/scale,insets.bottom/scale,insets.right/scale};
    CGRect resultRect = UIEdgeInsetsInsetRect(view.bounds, scaledInsets);
    // 判断给定坐标点是否在区域内
    if (CGRectContainsPoint(resultRect, convertedPoint)) {
        return YES;
    }
    return NO;
}


/**************************************************************************/
- (UIView *)ls_firstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    UIView *firstResponder = nil;
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        firstResponder = [subview ls_firstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}

// view分类方法
- (UIViewController *)ls_belongViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


///移除所有的子视图         如果是弹窗视图AlertView,不能调用此方法,回导致弹窗子控件全部被移除而不能显示弹窗
- (void)ls_removeAllSubViews {
    for(UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}

///移除所有的子视图 如果是弹窗视图AlertView,不能调用此方法,回导致弹窗子控件全部被移除而不能显示弹窗
- (void)ls_removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

///移除所有的子视图 如果是弹窗视图AlertView,不能调用此方法,回导致弹窗子控件全部被移除而不能显示弹窗
- (void)ls_removeAllSubViews_ {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

///移除所有的子视图 如果是弹窗视图AlertView,不能调用此方法,回导致弹窗子控件全部被移除而不能显示弹窗
- (void)ls_removeAllSubviews_ {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

/// 更新尺寸，使用autolayout布局时需要刷新约束才能获取到真实的frame
- (void)ls_updateFrame{
    [self updateConstraints];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

/**
 使用masonry设置view后发现，设置任意角的圆角不起作用。
 解决方法：1.<tableview的cell里面切角有时不行>
 当设置完控件的约束，需要调用layoutIfNeeded 函数进行布局，然后所约束的控件才会按照约束条件，生成当前布局相应的frame和bounds。这样就可以利用这两个属性来进行图片圆角剪裁
 [self layoutIfNeeded];//这句代码很重要，不能忘了
 [self setRoundedCorners:UIRectCornerTopLeft radius:6];
 
 解决方法：2.<tableView的cell里面切角也可以>
  先给要切圆角的view 设置frame(x,y和高度可以随便设置,宽度最好设置准确一点,设置为view的最终宽度),
    view.frame = CGRectMake(0, 0, view的真实/准确的最终宽度, 100);
 然后:
    [self setRoundedCorners:UIRectCornerTopLeft radius:6];
 */
- (void)ls_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

/// 设置部分圆角(绝对布局)
/// @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
/// @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/// 设置部分圆角(相对布局)
/// @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
/// @param radii 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
/// @param rect 需要设置的圆角view的rect
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 
 CAGradientLayer可以通过colors属性设置多个有序渐变颜色，并在CALayer的坐标系内对渐变方向和渐变位置做调整。CALayer的坐标系用(x, y)表示，左上角为(0, 0)，右下角为(1, 1)， 如下：
     (0,0)       (0.5,0)         (1,0)
    (0,0.5)     (0.5,0.5)       (1,0.5)
     (0,1)       (0.5,1)         (1,1)
 
 
 基于坐标系，可以通过startPoint和endPoint两个属性设置渐变方向。下面是一些常用的渐变方向实现方式：
 
 // 从上至下（x相同，y控制方向）
 gradientLayer.startPoint = CGPointMake(.0, .0);
 gradientLayer.endPoint = CGPointMake(.0, 1.0);

 // 从下至上（x相同，y控制方向）
 gradientLayer.startPoint = CGPointMake(.0, 1.0);
 gradientLayer.endPoint = CGPointMake(.0, .0);

 // 从左至右（y相同，x控制方向）
 gradientLayer.startPoint = CGPointMake(.0, .0);
 gradientLayer.endPoint = CGPointMake(1.0, .0);

 // 从右至左（y相同，x控制方向）
 gradientLayer.startPoint = CGPointMake(1.0, .0);
 gradientLayer.endPoint = CGPointMake(.0, .0);

 // 从左上至右下（x和y控制方向）
 gradientLayer.startPoint = CGPointMake(.0, .0);
 gradientLayer.endPoint = CGPointMake(1.0, 1.0);
 基于坐标系，可以通过locations属性设置颜色组的渐变位置。locations的元素个数需要和colors一致，指明第n个颜色在何处与相邻的颜色开始渐变

!!! 在不设置locations属性时，相邻颜色会充分渐变，也就是说在渐变方向上，不会存在同色值的相邻像素；
 而在指定了locations之后，第n个颜色会在第n个location处与相邻的颜色开始渐变，此location之外的区域是纯色

 */

// 渐变色
- (CAGradientLayer *)ls_gradientLayerWithColors:(NSArray *)colors
                                          frame:(CGRect)frm
                                      locations:(NSArray *)locations
                                     startPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil || [colors isKindOfClass:[NSNull class]] || colors.count == 0){
        return nil;
    }
    if (locations == nil || [locations isKindOfClass:[NSNull class]] || locations.count == 0){
        return nil;
    }
    NSMutableArray *colorsTemp = [NSMutableArray new];
    for (UIColor *color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsTemp addObject:(__bridge id)color.CGColor];
        }
    }
    
    gradientLayer.frame =  frm;
    // 设置渐变颜色数组
    gradientLayer.colors = colorsTemp;
    // 设置渐变起始点
    gradientLayer.startPoint = startPoint;
    // 设置渐变结束点
    gradientLayer.endPoint = endPoint;
    // 设置渐变颜色分布区间，不设置则均匀分布
    // gradientLayer.locations = @[@(0.0), @(1.0)];
    gradientLayer.locations = locations;
    // 设置渐变类型，不设置则按像素均匀变化
    // gradientLayer.type = kCAGradientLayerAxial;// 按像素均匀变化
    return gradientLayer;
}

// 渐变色
- (void)ls_gradientBgColorWithColors:(NSArray *)colors
                           locations:(NSArray *)locations
                          startPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint {
    CAGradientLayer *layer = [self ls_gradientLayerWithColors:colors
                                                        frame:self.bounds
                                                    locations:locations
                                                   startPoint:startPoint
                                                     endPoint:endPoint];
    [self.layer insertSublayer:layer atIndex:0];
}

@end
