//
//  UITableView.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#ifndef UITableView_h
#define UITableView_h

//UITableView 设置成UITableViewStylePlain 之后，如果设置section的 headview或者footview  会有悬浮效果。

//如果不想要悬浮效果，需要设置成UITableViewStyleGrouped 。
//
//虽然这样设置不会悬浮，但是我们没设置headview或者footview 也会自动显示一个默认高度的view。
//
//如果只想显示自定义的headerview 不想显示footview ，就需要重写设置headerview和footview 的两个代理方法
//
//-(UIView*)tableView:(UITableView*)tableViewviewForFooterInSection:(NSInteger)section{
//
//自定义view
//
//    return nil;
//
//}
//
//-(UIView*)tableView:(UITableView*)tableViewviewForHeaderInSection:(NSInteger)section{
//
//自定义view
//
//    return nil;
//
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return0;
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return10;
//
//}


#endif /* UITableView_h */
