//
//  LSAlertView.h
//  LSProjectTool
//
//  Created by Xcode on 16/9/29.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAlertView : UIView
{
    NSMutableArray *_dataArray;
    
    NSString *_key;
    
    UIViewController *_ls_vc;
}

/*!
 *  @brief block块 参数为用户选择的数据
 */
@property (nonatomic, copy) void(^AlertViewSelectedResult)(UITableView *tableView, NSIndexPath *selectedIndexPath);


/*!
 *  @brief 初始化方法
 *
 *  @param frame frame
 *  @param array 装有数据的数组
 *
 *  @return
 */
- (instancetype)initWithViewController:(UIViewController *)vc andArray:(NSArray *)array andKey:(NSString *)key;


- (void)show;

@end
