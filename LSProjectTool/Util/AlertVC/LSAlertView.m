//
//  LSAlertView.m
//  LSProjectTool
//
//  Created by Xcode on 16/9/29.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

///cellID
#define kCellID @"LSAlertViewCellId"

#define kScreenBounds ([UIScreen mainScreen].bounds)
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height


#define MAS_SHORTHAND_GLOBALS
#import "LSAlertView.h"
#import "Masonry.h"

@interface LSAlertView () <UITableViewDelegate, UITableViewDataSource>

///弹窗控件所在的view
@property (nonatomic, strong) UIView *ls_alertView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat ls_rowHeight;

@end

@implementation LSAlertView



/*!
 *  @brief 初始化方法
 *
 *  @param frame frame
 *  @param array 装有数据的数组
 *
 *  @return
 */
- (instancetype)initWithViewController:(UIViewController *)vc andArray:(NSArray *)array andKey:(NSString *)key {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        _dataArray = [array mutableCopy];
        _key = key;
        _ls_vc = vc;
        
        if (_ls_rowHeight <= 0) { //每个cell的高度
            _ls_rowHeight = 44;
        }
        
        //tableview的高度
        CGFloat tableViewHeight = _dataArray.count > 5 ? _ls_rowHeight * 5 : _ls_rowHeight * _dataArray.count;
        
        //设置视图
        [self configSubviews:tableViewHeight];
    }
    return self;
}

///设置视图
- (void)configSubviews:(CGFloat)tableViewHeight {
    //设置背景
    self.backgroundColor = [UIColor colorWithRed:0.37 green:0.36 blue:0.36 alpha:0.5];
    
    _ls_alertView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth * 0.8, tableViewHeight)];
    [self addSubview:_ls_alertView];
    _ls_alertView.center = self.center;
    _ls_alertView.backgroundColor = [UIColor whiteColor];
    //设置圆角
    _ls_alertView.layer.cornerRadius = 5;
    _ls_alertView.layer.masksToBounds = YES;
    
    //tableView
    [self setupTableView:tableViewHeight];
}

//创建tableview
- (void)setupTableView:(CGFloat)tableViewHeight {
    //创建tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.8, tableViewHeight) style:UITableViewStylePlain];
    [_ls_alertView addSubview:_tableView];


    //设置代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO; //弹簧效果
    //设置分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - tableView 代理方法
//返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//返回每个分区cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = kCellID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //取消cell的选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:245.0/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter; //居中
    
    //数据显示
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text = dic[_key];
    
    return cell;
}
//cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_AlertViewSelectedResult) {
        _AlertViewSelectedResult(tableView, indexPath);
        
        [self exitToBottom];
    }
}

//返回每个row的的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _ls_rowHeight;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        [self exitToBottom];
    }
}

- (void)show {
    [_ls_vc.view addSubview:self];
    
    [self fadeInAnimate];
}

/**
 *  出场/退场/重试动画
 */
- (void)fadeInAnimate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)exitToBottom {
    [UIView animateWithDuration:0.3 animations:^{
        _ls_alertView.transform = CGAffineTransformTranslate(_ls_alertView.transform, 0, kScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview]; //移除视图
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
