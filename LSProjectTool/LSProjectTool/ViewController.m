//
//  ViewController.m
//  LSProjectTool
//
//  Created by Xcode on 16/7/14.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
//


#import "ViewController.h"
//#import <AVFoundation/AVFoundation.h>
//#import "LSCustomCamera.h"
#import "LSTextView.h"
#import "LSPhotographVC.h"
//#import "Person.h"
#import "YPhotoManager.h"


#import "FengChe.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LSTextView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H;


@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) UIView *demoView;



@property (nonatomic, strong) FengChe *f;

@end




@implementation ViewController


#define kuu @"uu"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputView.ls_placeholder(@"123456789").ls_placeholderColor([UIColor redColor]).ls_maxNumberOfLines(3);
    
    
     self.f = [[FengChe alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
    
     
    
    //语法糖
    self.f = ({
        
        FengChe *f = [[FengChe alloc] init];
    
        
        f;
    });
    
    
    NSArray *array = @[@1, @2, @3, @4, @5, @6];
    
    NSString *str = [array componentsJoinedByString:@","];
    
    
    NSLog(@"__________________________：%@", str);
    
}

- (IBAction)btnAction:(id)sender {
    LSPhotographVC *vc = [[LSPhotographVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)dismiss:(id)sender {
    
    [self.view addSubview:self.f];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
