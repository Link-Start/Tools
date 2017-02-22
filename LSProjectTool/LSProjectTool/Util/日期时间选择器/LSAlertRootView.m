//
//  LSAlertRootView.m
//  LSProjectTool
//
//  Created by Xcode on 16/9/30.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSAlertRootView.h"

@interface LSAlertRootView ()

@property (nonatomic, strong) UIView *containerView;

/// 存放约束数组 的数组
@property (nonatomic, strong) NSMutableArray *constraintsArray;

@end

@implementation LSAlertRootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commontInin];
    }
    return self;
}

- (void)commontInin {
    UIView *view;
    //获取和控制器同名的字符串
    id objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = (UIView *)object;
            break;
        }
    }
    
    if (view) {
        _containerView = view;
         // 打开自动布局(Autoresizing和autoLayout不能同时存在)
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self setNeedsUpdateConstraints];
    }
    
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.constraintsArray removeAllObjects];
    
    UIView *view = self.containerView;
    
    if (view) {
         NSDictionary *viewDic = @{@"view":view};
        //约束
        NSArray *array1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:viewDic];
        NSArray *array2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:viewDic];
        // 把约束添加到数组中
        [self.constraintsArray addObject:array1];
        [self.constraintsArray addObject:array2];
        // 激活约束
        [NSLayoutConstraint activateConstraints:array1];
        [NSLayoutConstraint activateConstraints:array2];
    }
}



- (NSMutableArray *)constraintsArray {
    if (!_constraintsArray) {
        _constraintsArray = [NSMutableArray array];
    }
    return _constraintsArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
