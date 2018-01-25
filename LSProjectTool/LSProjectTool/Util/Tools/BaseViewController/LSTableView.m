//
//  LSTableView.m
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/22.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

#import "LSTableView.h"

@interface LSTableView ()
@property (nonatomic, strong) UITableView *ls_tableView;
@end

@implementation LSTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.ls_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //iOS8引入Self-Sizing 之后，我们可以通过实现estimatedRowHeight相关的属性来展示动态的内容
    //Self-Sizing在iOS11下是默认开启的
    //iOS11下不想使用Self-Sizing的话，可以通过以下方式关闭
    self.ls_tableView.estimatedRowHeight = 0;
    self.ls_tableView.estimatedSectionHeaderHeight = 0;
    self.ls_tableView.estimatedSectionFooterHeight = 0;
    
    //如果你使用了Masonry，那么你需要适配safeArea

//    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(100);
//        make.left.equalTo(self.leftLabel.mas_right);
//        make.right.equalTo(self.view);
//   make.bottom.equalTo(self.view.mas_bottom);
// 1. 改为 make.bottom.equalTo(self.view.mas_bottomMargin); 或者
// 2. 改为  if (@available(iOS 11.0, *)) {
//    make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//} else {
//    make.bottom.equalTo(self.view.mas_bottom);
//}
//    }];

#ifdef __IPHONE_11_0
    if ( [self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.ls_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    if(kDevice_Is_iPhoneX && CGRectGetHeight(self.view.frame) == kLS_ScreenHeight - kLS_TopHeight){
        self.ls_tableView.contentInset = UIEdgeInsetsMake(0, 0, kLS_iPhoneX_Home_Indicator_Height, 0);
        self.ls_tableView.scrollIndicatorInsets = self.ls_tableView.contentInset;
    }
#endif
    
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
