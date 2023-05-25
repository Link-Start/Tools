//
//  UITextField自动补全输入.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/5/12.
//  Copyright © 2023 Link-Start. All rights reserved.
//  UITextFiled自动补全输入，选中补全内容。NSRange和UITextRange的相互转换。
//  https://blog.csdn.net/darkmengziyan2013/article/details/43528445?spm=1001.2101.3001.6650.5&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-5-43528445-blog-115621677.235%5Ev35%5Epc_relevant_default_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-5-43528445-blog-115621677.235%5Ev35%5Epc_relevant_default_base

//  原文链接：https://blog.csdn.net/darkmengziyan2013/article/details/43528445


#ifndef UITextField_______h
#define UITextField_______h

有个需求就是 需要用户输入几位以后账号，可以根据本地存储的登录成功的账号，进行自动补全，并且补全内容为选中状态，不影响用户的新输入。

      研究了一下，下面是完整的实现的方法。

      补充个下载地址http://download.csdn.net/detail/darkmengqi/8426463

     写在 textFiled的delegate里面，这样当有输入时会调用此方法。

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

   if ([string isEqualToString:@""]) {//删除的话
       return YES;
   }
   NSMutableString *text = [[NSMutableString alloc]initWithCapacity:0];
   [text appendString:textField.text];
   [text deleteCharactersInRange:range];//在选中的位置 插入string
   [text insertString:string atIndex:range.location];

   if (text.length>2) { // 限制从2个以上才开始匹配  根据需求 自己设定
       NSString *behind = [self matchString:text]; //匹配是否有开头相同的
       if (behind) {
           [text appendString:behind];
           textField.text = text;
           UITextPosition *endDocument = textField.endOfDocument;//获取 text的 尾部的 TextPositext

//          选取尾部补全的String
           UITextPosition *end = [textField positionFromPosition:endDocument offset:0];
           UITextPosition *start = [textField positionFromPosition:end offset:-behind.length];//左－右＋
           textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
           return NO;
       }else{
           return YES;
       }
   }
   return YES;
}
    顺便粘贴下 匹配字符的 代码，很简单。

-(NSString *)matchString:(NSString *)head{
   for (int i = 0; i<[_array count]; i++) {
       NSString *string = _array[i];
       if ([string hasPrefix:head]) {
           return  [string substringFromIndex:head.length];
       }
   }
   return nil;
}

    这样就实现了一开始说的那个需求。



    下面再说一下  光标的 一些问题。

    获取光标的位置

    UITextRange *selectedRange = [textField selectedTextRange];

    根据NSRange 转换成 NSTextRange

 UITextPosition *beginning = textView.beginningOfDocument;
 UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
 UITextPosition *end = [textView positionFromPosition:start offset:range.length];
 UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end]];
  根据NSTextRange转换成 NSRange

- (NSRange) selectedRange:(UITextField *)textField
{
   UITextPosition* beginning = textField.beginningOfDocument;
   UITextRange* selectedRange = textField.selectedTextRange;
   UITextPosition* selectionStart = selectedRange.start;
   UITextPosition* selectionEnd = selectedRange.end;
   const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
   const NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];
}




#endif /* UITextField_______h */
