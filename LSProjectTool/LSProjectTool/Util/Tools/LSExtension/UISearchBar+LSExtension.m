//
//  UISearchBar+LSExtension.m
//  COSMOplat
//
//  Created by macbook v5 on 2018/10/27.
//  Copyright © 2018年 Ruitu. All rights reserved.
//

#import "UISearchBar+LSExtension.h"
#import "UIColor+LSExtension.h"

@implementation UISearchBar (LSExtension)


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, kLS_ScreenWidth,44)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    
    item.tintColor = [UIColor colorFromHexString:@"#333333"];
    
    bar.items = @[space,item];
    self.inputAccessoryView = bar;
}

- (void)textFieldDone {
    NSLog(@"button click");
    [self resignFirstResponder];//收回键盘
}

@end
