//
//  NSArray数据.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/12.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#ifndef NSArray___h
#define NSArray___h


#pragma - mark - makeObjectsPerformSelector
// https://blog.csdn.net/chaoge321/article/details/90243798
// makeObjectsPerformSelector

makeObjectsPerformSelector：这是数组用的方法，类似于for循环。

//  makeObjectsPerformSelector:@selector(method:)：意为数组中的每个元素都执行method方法
//  makeObjectsPerformSelector:@selector(method:) withObject:obj
//      ：表示数组中的每个元素都执行method方法，并把obj对象作为参数传到method方法中。
//      使用该方法时需要注意，withObject的参数需要为对象，而不是基本数据类型等。
//  如想将一个btn数组的按钮都设为selected，可以用
//  [self.selectedBtnArr makeObjectsPerformSelector:@selector(setSelected:) withObject:@(YES)]; // 这是有效的。
//  [self.selectedBtnArr makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)]; //但若想设置为NO的话，则无效。

//  这是因为YES和NO都为BOOL类型，设置为YES时，传递的为非0的指针，所以会设置 btn.selected = YES
//  但若设置为NO时，传递的仍为非0的指针，所以执行的结果仍是 btn.selected = YES。
//  此时可以用:[self.selectedBtnArr makeObjectsPerformSelector:@selector(setSelected:) withObject:nil];
//  来达到 btn.selected = NO 的效果。但不推荐该法，应使用for循环处理。







#endif /* NSArray___h */
