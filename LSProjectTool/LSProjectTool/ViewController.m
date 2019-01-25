//
//  ViewController.m
//  LSProjectTool
//
//  Created by Xcode on 16/7/14.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
//


#import "ViewController.h"
#import "LSTextView.h"
#import "LSBaseViewController.h"
#import "NetworkRequest.h"
#import "LSNetworking.h"
#import "CeshiVC.h"
#import "Function.h"
#import "JsonTools.h"


@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LSTextView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) UIView *demoView;


@property (nonatomic, strong) UIButton *btn;

@end




@implementation ViewController


#define kuu @"uu"


- (void)viewDidLoad {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *dict = [Function getDicFromResponseObject:data];
//     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    
    
    
    [JsonTools propertyCodeWithDictionary:dict];
    
//    self.inputView.ls_placeholder(@"123456789").ls_placeholderColor([UIColor redColor]).ls_maxNumberOfLines(3);
//
//
//     self.f = [[FengChe alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
//
//    UILabel *l = [[UILabel alloc] init];
//    l = ({
//        l.text = @"..";
//        l;
//    });
//    //语法糖
//    self.f = ({
//        FengChe *f = [[FengChe alloc] init];
//        f;
//    });
//    NSArray *array = @[@1, @2, @3, @4, @5, @6];
//
//    NSString *str = [array componentsJoinedByString:@","];
//
//    NSLog(@"__________________________：%@", str);

}

- (void)btnAction {
    
}

- (IBAction)btnAction:(id)sender {
    CeshiVC *vc = [[CeshiVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)dismiss:(id)sender {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
