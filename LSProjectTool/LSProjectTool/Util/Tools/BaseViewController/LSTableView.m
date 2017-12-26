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
    
    
//    if (@available(iOS 11.0, *)) {
//        make.edges.equalTo()(self.view.safeAreaInsets)
//    } else {
//        make.edges.equalTo()(self.view)
//    }

    
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
