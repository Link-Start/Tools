//
//  UIButton+ImageTitleSpace.m
//  MadnessLAB
//
//  Created by Alex Yang on 2018/4/21.
//  Copyright © 2018年 Link_Start. All rights reserved.
//

#import "UIButton+ImageTitleSpace.h"
#import <objc/runtime.h>

@implementation UIButton (ImageTitleSpace)

static char *ls_typeKey = "ls_edgeInsetsStyle";
static char *ls_spaceKey = "ls_edgeInsetsSpace";

- (void)setLs_type:(NSInteger)ls_type {
    
    /*
     objc_AssociationPolicy参数使用的策略：
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略
     
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;
     */
    /*
     关联方法：
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     
     参数：
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     */
    //关联方法
    NSString *temS = [NSString stringWithFormat:@"%ld", (long)ls_type]; //不能直接使用ls_type(NSInteger类型的)
    objc_setAssociatedObject(self, ls_typeKey, temS, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (self.ls_space) {
        [self layoutButtonWithEdgeInsetsStyle:ls_type imageTitleSpace:self.ls_space];
    } else {
        [self layoutButtonWithEdgeInsetsStyle:ls_type imageTitleSpace:5];
    }
}

- (NSInteger)ls_type {
    return [objc_getAssociatedObject(self, &ls_typeKey) integerValue];
}

///间隔
- (void)setLs_space:(CGFloat)ls_space {
    //关联方法
    NSString *temStr = [NSString stringWithFormat:@"%f", ls_space];
    objc_setAssociatedObject(self, ls_spaceKey, temStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ls_space {
    return [objc_getAssociatedObject(self, &ls_spaceKey) doubleValue];
}

- (void)layoutButtonWithEdgeInsetsStyle:(LSButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    /**
     *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    
    switch (style) {
        case LSButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case LSButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case LSButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case LSButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    if (self.titleLabel.text.length > 0) {
        self.titleEdgeInsets = labelEdgeInsets;
    }
    if (self.imageView.image) {
        self.imageEdgeInsets = imageEdgeInsets;
    }
//    if (self.titleLabel.text.length > 0 && self.imageView.image) {//添加判断，防止出现偏移
//        self.titleEdgeInsets = labelEdgeInsets;
//        self.imageEdgeInsets = imageEdgeInsets;
//    }
}

//不能写这个方法，否则按钮点击改变selected 状态会失效
//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    if (self.ls_type && self.ls_space) {
//         [self layoutButtonWithEdgeInsetsStyle:self.ls_type imageTitleSpace:self.ls_space];
//    }
//}

#pragma mark - 扩大按钮响应区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    
//    CGRect bounds = self.bounds;
//    //若原热区小于44x44，则放大热区，否则保持原大小不变
//    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
//    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//    return CGRectContainsPoint(bounds, point);
    
    CGRect bounds = self.bounds;
       
       if (self.tag == 413) {
           //若原热区小于44x44，则放大热区，否则保持原大小不变
           CGFloat widthDelta = MAX(self.enlargeSize.width, 0);
           CGFloat heightDelta = MAX(self.enlargeSize.height, 0);
           bounds = CGRectInset(bounds, widthDelta, heightDelta);
       } else {
           //若原热区小于44x44，则放大热区，否则保持原大小不变
           CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
           CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
           bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
       }
       return CGRectContainsPoint(bounds, point);
}


@end
