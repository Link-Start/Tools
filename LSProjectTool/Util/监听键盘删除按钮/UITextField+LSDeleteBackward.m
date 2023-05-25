//
//  UITextField+LSDeleteBackward.m
//  Pension
//
//  Created by 刘晓龙 on 2023/5/11.
//  Copyright © 2023 ouba. All rights reserved.
//  监听键盘删除按钮，textField内无文本时也能监听到

#import "UITextField+LSDeleteBackward.h"
#import <objc/runtime.h>

NSString * const LSTextFieldDidDeleteBackwardNotification = @"com.lxl.textfield.did.notification";


@implementation UITextField (LSDeleteBackward)

+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(ls_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)ls_deleteBackward {
    [self ls_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <LSTextFieldDeleteBackwardDelegate> delegate  = (id<LSTextFieldDeleteBackwardDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LSTextFieldDidDeleteBackwardNotification object:self];
}

/**
 // https://www.jianshu.com/p/eaa2315fca7f
 UITextPosition：
 beginningOfDocument：文档的起点 ，0的位置
 endOfDocument：          文档的结束点。text.location + 1的位置

 UITextRange：
 selectedTextRange可以设置文本的选中。文本在编辑时,selectedTextRange也就是光标的位置。
 
 //https://blog.csdn.net/u013712343/article/details/115621677
 光标位置的获取
    在textField中，有一个属性称之为selectedTextRange，这个属性为UITextRange类型，包含[start,end)两个值，
    通过实验我们可以发现，在没有文字被选取时，start代表当前光标的位置，而end＝0；
    当有区域被选择时，start和end分别是选择的头和尾的光标位置，从0开始，并且不包含end，例如选择了0～3的位置，则start＝0，end＝4。
 光标的移动
    通过setSelectedTextRange:方法可以设置选取范围，我们只要设置一个选取单个字符的范围，即可移动光标而不选中。

 关键方法
    // 获取以from为基准的to的偏移，例如abcde，光标在c后，则光标相对文尾的偏移为-2。
    - (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition;
    // 获取以from为基准偏移offset的光标位置。
    - (nullable UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset;
    // 创建一个UITextRange
    - (nullable UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition;
*/

/// 点击键盘上的删除按钮时，将光标移到文本最后
//- (void)textFieldDidDeleteBackward:(UITextField *)textField {
//
//    UITextRange *range = textField.selectedTextRange;
//
//    UITextPosition *end = [textField positionFromPosition:range.end inDirection:UITextLayoutDirectionRight offset:textField.text.length];
//    if (end) {
//        [textField setSelectedTextRange:[textField textRangeFromPosition:end toPosition:end]];
//    }
//}


@end
