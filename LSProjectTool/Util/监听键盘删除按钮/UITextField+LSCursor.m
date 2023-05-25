//
//  UITextField+LSCursor.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/5/11.
//  Copyright © 2023 Link-Start. All rights reserved.
//  UITextField的光标操作扩展(UITextRange,UITextPosition)(处理限定字数输入)

#import "UITextField+LSCursor.h"

@implementation UITextField (LSCursor)

/// 获取光标位置
- (NSInteger)ls_getCursorPosition {
    
    // 基于文首计算出到光标的偏移数值
    // beginningOfDocument：文首的位置
    // selectedTextRange.start：光标的位置
    // 获取以from为基准的to的偏移，例如abcde，光标在c后，则光标相对文尾的偏移为-2。
    return [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    
    return 0;
}
/// 从当前位置偏移
- (void)ls_makeOffsetFromCurrentPosition:(NSInteger)offset {
    
    // 先获取一个基于文尾的偏移，然后加上要施加的偏移，再重新根据文尾计算位置，最后利用选取来实现光标定位
    UITextRange *selectedRange = [self selectedTextRange];
    
    NSInteger currentOffset = [self offsetFromPosition:self.endOfDocument toPosition:selectedRange.end];
    
    currentOffset += offset;
    
    UITextPosition *newPos = [self positionFromPosition:self.endOfDocument offset:currentOffset];
    
    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
}
/// 从头偏移
- (void)ls_makeOffsetFromBeginningPosition:(NSInteger)offset {
    
    // 先把光标移动到文首，然后再调用上面实现的偏移函数
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:begin offset:0];
    UITextRange *range = [self textRangeFromPosition:start toPosition:start];
    [self setSelectedTextRange:range];
    [self ls_makeOffsetFromCurrentPosition:offset];
}


@end


/**
 
 
 UITextField的光标操作扩展(UITextRange,UITextPosition)(处理限定字数输入)
 简介
 在iOS开发中，有时候需要完全自主的定义键盘，用于完整的单词输入，例如计算机应用中，需要一次性的输入sin(，在移动光标时要完整的跳过sin(，在删除时也要完整的删除，这就需要对光标的位置进行精确控制，而iOS并没有相关的函数可以直接操作光标，只给出了选择某个区域的功能，本文将介绍基于区域选择设计的UITextField扩展，用于获取光标位置以及移动光标。

 实现原理
 光标位置的获取
 在textField中，有一个属性称之为selectedTextRange，这个属性为UITextRange类型，包含[start,end)两个值，通过实验我们可以发现，在没有文字被选取时，start代表当前光标的位置，而end＝0；当有区域被选择时，start和end分别是选择的头和尾的光标位置，从0开始，并且不包含end，例如选择了0～3的位置，则start＝0，end＝4。

 光标的移动
 通过setSelectedTextRange:方法可以设置选取范围，我们只要设置一个选取单个字符的范围，即可移动光标而不选中。

 关键属性
 // 内容为[start,end)，无论是否有选取区域，start都描述了光标的位置。

 @property (nullable, readwrite, copy) UITextRange *selectedTextRange;

 // 文首和文尾的位置

 @property (nonatomic, readonly) UITextPosition *beginningOfDocument;

 @property (nonatomic, readonly) UITextPosition *endOfDocument;

 关键方法
 // 获取以from为基准的to的偏移，例如abcde，光标在c后，则光标相对文尾的偏移为-2。

 - (NSInteger)offsetFromPosition:(UITextPosition *)from toPosition:(UITextPosition *)toPosition;

 // 获取以from为基准偏移offset的光标位置。

 - (nullable UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset;

 // 创建一个UITextRange

 - (nullable UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition;

 具体实现
 下面的代码为UITextField创建了一个分类(Category)，包含三个方法，分别用于获取光标位置、从当前位置偏移、从头偏移。
 #import <UIKit/UIKit.h>

  
 @interface UITextField (Extension)

  
 - (NSInteger)curOffset;

 - (void)makeOffset:(NSInteger)offset;

 - (void)makeOffsetFromBeginning:(NSInteger)offset;

  
 @end

 #import "UITextField+Extension.h"

  
 @implementation UITextField (Extension)

  
 - (NSInteger)curOffset{

  
 // 基于文首计算出到光标的偏移数值。

 return [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];

  
 }

  
 - (void)makeOffset:(NSInteger)offset{

  
 // 实现原理是先获取一个基于文尾的偏移，然后加上要施加的偏移，再重新根据文尾计算位置，最后利用选取来实现光标定位。

 UITextRange *selectedRange = [self selectedTextRange];

 NSInteger currentOffset = [self offsetFromPosition:self.endOfDocument toPosition:selectedRange.end];

 currentOffset += offset;

 UITextPosition *newPos = [self positionFromPosition:self.endOfDocument offset:currentOffset];

 self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];

  
 }

  
 - (void)makeOffsetFromBeginning:(NSInteger)offset{

  
 // 先把光标移动到文首，然后再调用上面实现的偏移函数。

 UITextPosition *begin = self.beginningOfDocument;

 UITextPosition *start = [self positionFromPosition:begin offset:0];

 UITextRange *range = [self textRangeFromPosition:start toPosition:start];

 [self setSelectedTextRange:range];

 [self makeOffset:offset];

  
 }

  
 @end

  

 2.应用:http://www.cnblogs.com/blogfantasy/p/5304260.html

  

  

 首先监听UITextfield值的改变有以下三种方法:

 1、KVO方式
 [textField addObserver:self forKeyPath:@"text" options:0 context:nil];
 2、直接添加监视
 [textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
 3、注册消息通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:textField];

 此方法有局限,1能监听输入框的直接赋值,2  3能监听输入框的输入.

 此外就是可以使用ReactiveCocoa,来同时监听输入和赋值

 此外就是,使用textview的代理方法,

 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

 这样实现的结果是：对于纯字符的统计没有什么问题，当输入的字符超过限制时输入框便截取最大限制长度的字符串。但是，有个问题，当使用拼音输入法时，该委托方法中的最后一个参数string接受的是输入的字母，而不是选择的汉字，造成的结果是，当想输入文字“我在编程”，输入拼音“wozaibiancheng”，每输入一个字母便会进入委托方法，统计的字符长度是字母的长度，实际上汉字还未超过限制长度，但是字母的长度超过了导致无法继续输入。

 而且，致命的是，这个委托方法并不响应，选中候选汉字的过程，这就没有办法重新修正字符长度的统计了。

 所以实现的代码如下。

 <1>在init时候注册notification：

 [[NSNotificationCenter defaultCenter]addObserver:selfselector:@selector(textFiledEditChanged:)
                                            name:@"UITextFieldTextDidChangeNotification"
                                          object:myTextField];

 <2>实现监听方法：

  -(void)textFiledEditChanged:(NSNotification *)obj{

    UITextField *textField = (UITextField *)obj.object;
     
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textFieldpositionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
           
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
 }

 <3>在dealloc里注销掉监听方法，切记！

   -(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self
                                            name:@"UITextFieldTextDidChangeNotification"
                                          object:_albumNameTextField];
 }
 
 */
