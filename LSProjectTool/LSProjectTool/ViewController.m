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
#import "LSCollectionView.h"
#import "HXPhotoView.h"
#import "FengChe.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet LSTextView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *H;


@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) UIView *demoView;

@property (nonatomic, strong) LSCollectionView *collection;
@property (nonatomic, strong) HXPhotoView *photoView;
@property (nonatomic, strong) FengChe *f;

@end




@implementation ViewController


#define kuu @"uu"


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoView = [[HXPhotoView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.photoView];
    
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
//
//
//
//    //语法糖
//    self.f = ({
//
//        FengChe *f = [[FengChe alloc] init];
//
//
//        f;
//    });
//
//
//    NSArray *array = @[@1, @2, @3, @4, @5, @6];
//
//    NSString *str = [array componentsJoinedByString:@","];
//
//
//    NSLog(@"__________________________：%@", str);
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [btn setTitle:@"666666666" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(20, self.view.frame.size.height - 50, self.view.frame.size.width - 40, 40);
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    
}

- (IBAction)btnAction:(id)sender {

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
