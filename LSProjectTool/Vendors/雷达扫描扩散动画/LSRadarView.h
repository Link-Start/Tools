//
//  LSRadarView.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/5/9.
//  Copyright © 2022 Link-Start. All rights reserved.
//
// https://www.jb51.net/article/224922.htm
// 雷达视图、雷达扫描扩散动画
//
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LSRadarViewType) {
    /// 雷达扫描动画
    LSRadarViewTypeScan,
    /// 雷达，水波纹扩散动画
    LSRadarViewTypeDiffuse,
};


NS_ASSUME_NONNULL_BEGIN

@interface LSRadarView : UIView

/// 雷达 空心圆圈的颜色
@property (nonatomic, strong) UIColor *radarLineColor;
/// 扇形开始颜色，必须由RGBA值初始化 [UIColor colorWithRed: green: blue: alpha:]
@property (nonatomic, strong) UIColor *startColor;
///  扇形结束颜色，必须由RGBA值初始化 [UIColor colorWithRed: green: blue: alpha:]
@property (nonatomic, strong) UIColor *endColor;

/// 扫描 雷达 View
/// @param radius 半径
/// @param angle 角度
/// @param radarLineNum 雷达线数量
/// @param hollowRadius 空心圆半径
/// @return 扫描 雷达 View
+ (LSRadarView *)scanRadarViewWithRadius:(CGFloat)radius
                                   angle:(int)angle
                            radarLineNum:(int)radarLineNum
                            hollowRadius:(CGFloat)hollowRadius;


/// 扩散圆/雷达/水波纹 view
/// @param startRadius      扩散圆 起始的半径
/// @param endRadius          扩散圆 消失的半径
/// @param circleColor      扩散圆 的颜色
+ (LSRadarView *)diffuseRadarViewWithStartRadius:(CGFloat)startRadius
                                       endRadius:(CGFloat)endRadius
                                     circleColor:(UIColor *)circleColor;

/// 展示在targetView上
/// @param targetView <#targetView description#>
- (void)showTargetView:(UIView *)targetView;

- (void)dismiss;

/// 开始扫描动画
- (void)startAnimation;
/// 停止扫描动画
- (void)stopAnimation;



@end

NS_ASSUME_NONNULL_END


/**
 
 
 #import "ViewController.h"
 #import "RadarView.h"
   
 @interface ViewController ()
   
 @property (nonatomic, strong) RadarView * scanRadarView;
 @property (nonatomic, strong) RadarView * diffuseRadarView;
   
 @end
   
 @implementation ViewController
   
 - (void)viewDidLoad {
     [super viewDidLoad];
     // 扫描 类型 RadarView
 //    _scanRadarView = [RadarView scanRadarViewWithRadius:self.view.bounds.size.width*0.5 angle:400 radarLineNum:5 hollowRadius:0];
      
     // 扩散 类型 RadarView
     _diffuseRadarView = [RadarView diffuseRadarViewWithStartRadius:7 endRadius:self.view.bounds.size.width*0.5 circleColor:[UIColor whiteColor]];
 }
   
 - (void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
      
 //    [_scanRadarView showTargetView:self.view];
 //    [_scanRadarView startAnimatian];
      
     [_diffuseRadarView showTargetView:self.view];
     [_diffuseRadarView startAnimatian];
 }
   
 - (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
 }
   
 @end
 
 
 */
